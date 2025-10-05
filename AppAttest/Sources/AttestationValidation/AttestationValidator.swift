import CryptoKit
import Foundation
import X509

public enum AttestationValidationError: Error {
    case invalidCertificateChain
    case failedChallenge
    case incorrectSigningKey
    case wrongRelyingParty
    case reusedAttestationKey
    case wrongEnvironment
}

public struct AttestationValidator {
    private let validationDate: Date
    let appIDHash: Data
    private let environment: AttestationEnvironment

    public init(appID: String, environment: AttestationEnvironment) {
        self.init(
            appID: appID,
            environment: environment,
            validationDate: Date()
        )
    }

    init(appID: String,
         environment: AttestationEnvironment,
         validationDate: Date) {
        self.appIDHash = Data(SHA256.hash(data: Data(appID.utf8)))
        self.environment = environment
        self.validationDate = validationDate
    }

    /// Validate this AttestationStatement using the steps given in the Device Check documentation:
    /// https://developer.apple.com/documentation/devicecheck/attestation-object-validation-guide#Walking-through-the-validation-steps
    public func validate(
        attestation: any AttestationObject,
        challenge: Data,
        keyID: String
    ) async throws {
        // 1. Verify that the x5c array contains the intermediate and leaf certificates for App Attest
        // Verify the validity of the certificates using Apple’s App Attest root certificate.
        try await validateCertificateChain(
            attestation.statement.certificateChain
        )

        // 2. Create clientDataHash as the SHA256 hash of the one-time challenge
        //    Append that hash to the end of the authenticator data
        let compositeData = compose(
            authenticatorData: attestation.authenticatorData.rawValue,
            withClientData: challenge
        )

        // 3. Generate a new SHA256 hash of the composite item to create nonce.
        let nonce = calculateNonce(composite: compositeData)

        // 4. Obtain the value of the credCert extension with OID 1.2.840.113635.100.8.2
        //    which is a DER-encoded ASN.1 sequence.
        //
        //    `credCert` here refers to the leaf certificate (unique for each attestation)
        let leafCertificate = attestation.statement.certificateChain[0]
        let oidExtension = leafCertificate.extensions[
            oid: "1.2.840.113635.100.8.2"
        ]

        guard
            // Decode the sequence and extract the single octet string that it contains.
            // First six bytes represent the ASN.1 wrapping of a string
            // TODO: exploring how to use the Swift ASN.1 decode to extract the bytes properly.
            // https://swiftpackageindex.com/apple/swift-asn1/1.3.0/documentation/swiftasn1
            let octetString = oidExtension?.value
                .map({ [$0] })
                .reduce([], +)[6...],
            // Verify that the string equals nonce.
            nonce == Data(octetString)
        else {
            throw AttestationValidationError.failedChallenge
        }

        // 5. Create the SHA256 hash of the public key in credCert with X9.62 uncompressed point format,
        //    and verify that it matches the key identifier from your app.
        let publicKeyHash = Data(
            SHA256.hash(data: leafCertificate.publicKey.subjectPublicKeyInfoBytes)
        ).base64EncodedString()

        guard publicKeyHash == keyID else {
            throw AttestationValidationError.incorrectSigningKey
        }

        // 6. Compute the SHA256 hash of your app’s App ID, and verify that it’s the same as the
        //    authenticator data’s relying party (RP) ID hash.
        guard attestation.authenticatorData.relyingPartyIDHash == appIDHash else {
            throw AttestationValidationError.wrongRelyingParty
        }

        // 7. Verify that the authenticator data’s counter field equals 0.
        guard attestation.authenticatorData.counter == 0 else {
            throw AttestationValidationError.reusedAttestationKey
        }

        // 8 . Verify that the authenticator data’s aaguid field is either appattestdevelop
        //     if operating in the development environment or appattest
        //     followed by seven 0x00 bytes if operating in the production environment.
        guard attestation.authenticatorData.environment == environment else {
            throw AttestationValidationError.wrongEnvironment
        }

        // 9. Verify that the authenticator data’s credentialId field is the same as the key identifier.
        guard attestation.authenticatorData.credentialID == keyID else {
            throw AttestationValidationError.incorrectSigningKey
        }
    }

    /// Validate this AssertionObject using the steps given in the Device Check documentation:
    /// https://developer.apple.com/documentation/devicecheck/validating-apps-that-connect-to-your-server#Verify-the-assertion
    public func validate(
        assertion: any AssertionObject,
        clientData: Data,
        keyID: String
    ) async throws {
        // 1. Compute clientDataHash as the SHA256 hash of clientData.
        // 2. Concatenate authenticatorData and clientDataHash and apply a SHA256 hash over the
        //    result to form nonce.
        let nonce = compose(
            authenticatorData: assertion.authenticatorData.rawValue,
            withClientData: clientData
        )

        // 3. Use the public key that you store from the attestation object to verify that the
        //    assertion’s signature is valid for nonce.

        // 4. Compute the SHA256 hash of the client’s App ID, and verify that it matches the
        //    RP ID in the authenticator data.
        guard assertion.authenticatorData.relyingPartyIDHash == appIDHash else {
            throw AttestationValidationError.wrongRelyingParty
        }

        // 5. Verify that the authenticator data’s counter value is greater than the value from
        //    the previous assertion, or greater than 0 on the first assertion.

        // 6. Verify that the embedded challenge in the client data matches the earlier challenge
        //    to the client.

    }

    func validateCertificateChain(_ certificateChain: [Certificate]) async throws {
        var validator = try Verifier(rootCertificates: .appAttest) {
            RFC5280Policy(validationTime: validationDate)
        }

        guard certificateChain.count == 2,
            let leafCertificate = certificateChain.first,
            let intermediateCertificate = certificateChain.last,
            case .validCertificate = await validator.validate(
                leafCertificate: leafCertificate,
                intermediates: CertificateStore([intermediateCertificate])
            )
        else {
            throw AttestationValidationError.invalidCertificateChain
        }
    }

    /// Create the nonce value by appending a hash of the client data to the authenticator data
    ///
    /// - Parameters:
    ///     - authenticatorData: defined in Web Authn standard: https://www.w3.org/TR/webauthn/#sctn-authenticator-data
    ///     - clientData: challenge for the request, can optionally also include request to protect against tampering
    func compose(
        authenticatorData: Data,
        withClientData clientData: Data
    ) -> Data {
        let clientDataHash = Data(SHA256.hash(data: clientData))
        return authenticatorData + clientDataHash
    }

    func calculateNonce(composite: Data) -> Data {
        Data(SHA256.hash(data: composite))
    }
}

extension AttestationValidator: Sendable { }
