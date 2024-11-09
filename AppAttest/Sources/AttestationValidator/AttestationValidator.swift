import Foundation
import X509

public enum AttestationValidationError: Error {
    case invalidCertificateChain
}

public struct AttestationValidator {
    let validationDate: Date

    public init() {
        validationDate = Date()
    }

    init(validationDate: Date) {
        self.validationDate = validationDate
    }

    /// Validate this AttestationStatement using the steps given in the Device Check documentation:
    /// https://developer.apple.com/documentation/devicecheck/attestation-object-validation-guide#Walking-through-the-validation-steps
    public func validate(attestation: AttestationObject) async throws {
        // 1. Verify that the x5c array contains the intermediate and leaf certificates for App Attest
        // a) Intermediate certificate
        // b) Leaf certificate
        let certificateChain = try attestation.statement
            .certificateChain
            .map(Certificate.init)

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
}
