@testable import AttestationValidation
import Foundation
import Testing

struct AttestationValidatorTests {
    func createValidator(
        appID: String = "Z86DH46P79.uk.co.oliverbinns.app-attest",
        environment: AttestationEnvironment = .development
    ) throws -> AttestationValidator {
        let components = DateComponents(
            year: 2024, month: 11, day: 10,
            hour: 12, minute: 0
        )

        let date = try #require(
            Calendar.current.date(from: components)
        )
        return AttestationValidator(
            appID: appID,
            environment: environment,
            validationDate: date
        )
    }

    @Test("Correctly calculates app ID hash")
    func appIDHash() throws {
        let sut = try createValidator()

        #expect(
            sut.appIDHash.base64EncodedString() ==
            "CVqj6oy4szHiiDd8cYbSvfsW9hVM3M8PUt8FUQyaY2w="
        )

        let appleExample = AttestationValidator(
            appID: "0352187391.com.apple.example_app_attest",
            environment: .development
        ).appIDHash

        #expect(
            appleExample.base64EncodedString() ==
            "FVhAM8lQuf6dUUziohGjJtcaprEBSrTG+i+9qdmqGKY="
        )
    }

    @Test("Validate a valid attestation - throws no errors")
    func validateValidAttestation() async throws {
        let sut = try createValidator()

        try await sut.validateCertificateChain(
            .valid
        )
    }

    @Test("Validate an expired attestation - throws error")
    func validateExpiredAttestation() async throws {
        let sut = try createValidator()

        await #expect(throws: AttestationValidationError.invalidCertificateChain) {
            try await sut.validateCertificateChain(
                .expired
            )
        }
    }

    @Test("Validate an empty attestation - throws error")
    func validateIncorrectNumberOfCertificates() async throws {
        let sut = try createValidator()

        await #expect(throws: AttestationValidationError.invalidCertificateChain) {
            try await sut.validateCertificateChain([])
        }
    }

    /// Apple's sample data appears to be incorrect:
    /// in particular the challenge specified does not appear to match.
    ///
    /// I have therefore generated my own sample data for this test:
    @Test("Correctly calculates client data hash")
    func clientDataHashCalculation() throws {
        let sut = try createValidator()

        let authenticatorData = try #require(Data(base64Encoded: """
        CVqj6oy4szHiiDd8cYbSvfsW9hVM3M8PUt8FUQyaY2xAAAAAAGFwcGF0d
        GVzdGRldmVsb3AAIG9BWcivC09zC1xluwgP1Zvt7I09591dFznuIYgnma
        TPpQECAyYgASFYIJ4vapTGQ5NqwIW+tkhsTOxBK4ubw1Ybxtoekioi8Zl
        eIlggcseOjEEzxVCQzl3Xbffk0yjwlwM+z+aFLqlIP4jl2LY=
        """.filter { !$0.isWhitespace }))

        let challenge = try #require(Data(base64Encoded: "XR79fDhFP05yhdB2"))

        let clientDataHash = sut.compose(
            authenticatorData: authenticatorData,
            withClientData: challenge
        )

        let expectedHash = """
        CVqj6oy4szHiiDd8cYbSvfsW9hVM3M8PUt8FUQyaY2xAAAAAAGFwcGF0d
        GVzdGRldmVsb3AAIG9BWcivC09zC1xluwgP1Zvt7I09591dFznuIYgnma
        TPpQECAyYgASFYIJ4vapTGQ5NqwIW+tkhsTOxBK4ubw1Ybxtoekioi8Zl
        eIlggcseOjEEzxVCQzl3Xbffk0yjwlwM+z+aFLqlIP4jl2LZjY4q/7C/r
        iwY2HxzZ+wM02bmPoA8paJJWlRAjSPQ8qg==
        """.filter { !$0.isWhitespace }

        #expect(clientDataHash.base64EncodedString() == expectedHash)
    }

    @Test("Correctly calculates nonce")
    func nonceCalculation() throws {
        let sut = try createValidator()

        let compositeItem = try #require(Data(base64Encoded: """
        FVhAM8lQuf6dUUziohGjJtcaprEBSrTG+i+9qdmqGKZAAAAAAGFwcGF0d
        GVzdAAAAAAAAAAAIG0qxIRfEyMyL1kj8L2dItvlDga3uAEh/OKyteZunp
        jWpQECAyYgASFYIIwuDKtvkiOXDn9atukv16TW1iGmDlSGRL8Zdk7x74U
        2IlggEfbCtrtTsrui00aBl+S+qyw2ysDk4k9B81EyyUdeXCR0ZXN0X3Nl
        cnZlcl9jaGFsbGVuZ2U=
        """.filter { !$0.isWhitespace }))

        let expectedNonce = try #require(
            Data(base64Encoded: "+20WKnF+yrF3iQBQb6lNZ+4MHcPUWxLN3oG+/Fblt+s=")
        )

        #expect(sut.calculateNonce(composite: compositeItem) == expectedNonce)
    }

    @Test("Correctly accepts a valid AttestationObject")
    func validAttestationObject() async throws {
        let sut = try createValidator()

        let challenge = try #require(Data(base64Encoded: "QhTa7IcbW7LTtQyi"))

        try await sut.validate(
            attestation: .valid,
            challenge: challenge,
            keyID: "fUKP+Fxptwo+n1dchr9Y5fRXoTZ6Dz8a6vOzNW03N1I="
        )
    }

    @Test("Attestation object certificate is validated")
    func expiredCertificate() async throws {
        let sut = try createValidator()

        let challenge = try #require(Data(base64Encoded: "QhTa7IcbW7LTtQyi"))

        await #expect(throws: AttestationValidationError.invalidCertificateChain) {
            try await sut.validate(
                attestation: .expired,
                challenge: challenge,
                keyID: ""
            )
        }
    }

    @Test("Attestation object doesn't match expected challenge")
    func mismatchingChallenge() async throws {
        let sut = try createValidator()

        let challenge = try #require(Data(base64Encoded: ""))

        await #expect(throws: AttestationValidationError.failedChallenge) {
            try await sut.validate(
                attestation: .valid,
                challenge: challenge,
                keyID: ""
            )
        }
    }

    @Test("Correctly rejects AuthenticatorData from a different app")
    func mismatchingRelyingPartyID() async throws {
        let sut = try createValidator(
            appID: "Z86DH46P79.uk.co.oliverbinns.conferences"
        )

        let challenge = try #require(Data(base64Encoded: "QhTa7IcbW7LTtQyi"))

        await #expect(throws: AttestationValidationError.wrongRelyingParty) {
            try await sut.validate(
                attestation: .valid,
                challenge: challenge,
                keyID: "fUKP+Fxptwo+n1dchr9Y5fRXoTZ6Dz8a6vOzNW03N1I="
            )
        }
    }

    @Test("Validator rejects object where count is greater than zero")
    func reusedAttestationKey() async throws {
        let sut = try createValidator()

        let challenge = try #require(Data(
            base64Encoded: "QhTa7IcbW7LTtQyi"
        ))

        let authenticatorData = try MockAuthenticatorData(
            counter: 1
        )
        let attestation = try MockAttestationObject(
            format: "apple-appattest",
            authenticatorData: authenticatorData,
            statement: .valid
        )

        await #expect(throws: AttestationValidationError.reusedAttestationKey) {
            try await sut.validate(
                attestation: attestation,
                challenge: challenge,
                keyID: "fUKP+Fxptwo+n1dchr9Y5fRXoTZ6Dz8a6vOzNW03N1I="
            )
        }
    }

    @Test("Validator rejects production attestation object in development environment")
    func incorrectProductionAttestationInDevelopment() async throws {
        let sut = try createValidator()

        let challenge = try #require(Data(
            base64Encoded: "QhTa7IcbW7LTtQyi"
        ))

        let productionData = try MockAuthenticatorData(
            environment: .production
        )
        let attestation = try MockAttestationObject(
            format: "apple-appattest",
            authenticatorData: productionData,
            statement: .valid
        )

        await #expect(throws: AttestationValidationError.wrongEnvironment) {
            try await sut.validate(
                attestation: attestation,
                challenge: challenge,
                keyID: "fUKP+Fxptwo+n1dchr9Y5fRXoTZ6Dz8a6vOzNW03N1I="
            )
        }
    }

    @Test("Validator rejects nil attestation object in production environment")
    func incorrectNilAttestationInProduction() async throws {
        let sut = try createValidator(environment: .production)
        let challenge = try #require(Data(
            base64Encoded: "QhTa7IcbW7LTtQyi"
        ))

        await #expect(throws: AttestationValidationError.wrongEnvironment) {
            try await sut.validate(
                attestation: .valid,
                challenge: challenge,
                keyID: "fUKP+Fxptwo+n1dchr9Y5fRXoTZ6Dz8a6vOzNW03N1I="
            )
        }
    }

    @Test("Validator rejects development attestation object in production environment")
    func incorrectDevelopmentAttestationInProduction() async throws {
        let sut = try createValidator(environment: .production)

        let challenge = try #require(Data(
            base64Encoded: "QhTa7IcbW7LTtQyi"
        ))

        let productionData = try MockAuthenticatorData()
        let attestation = try MockAttestationObject(
            format: "apple-appattest",
            authenticatorData: productionData,
            statement: .valid
        )

        await #expect(throws: AttestationValidationError.wrongEnvironment) {
            try await sut.validate(
                attestation: attestation,
                challenge: challenge,
                keyID: "fUKP+Fxptwo+n1dchr9Y5fRXoTZ6Dz8a6vOzNW03N1I="
            )
        }
    }

    @Test("Validator rejects Authenticator Data with incorrect key ID")
    func keyIDInAuthenticatorData() async throws {
        let sut = try createValidator()
        let challenge = try #require(Data(base64Encoded: "QhTa7IcbW7LTtQyi"))

        let data = try MockAuthenticatorData(
            credentialID: UUID().uuidString
        )
        let attestation = try MockAttestationObject(
            format: "apple-appattest",
            authenticatorData: data,
            statement: .valid
        )

        await #expect(throws: AttestationValidationError.incorrectSigningKey) {
            try await sut.validate(
                attestation: attestation,
                challenge: challenge,
                keyID: "fUKP+Fxptwo+n1dchr9Y5fRXoTZ6Dz8a6vOzNW03N1I="
            )
        }
    }
}
