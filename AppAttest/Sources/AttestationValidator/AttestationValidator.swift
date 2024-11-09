import Foundation
import X509

public struct AttestationValidator {
    /// Validate this AttestationStatement using the steps given in the Device Check documentation:
    /// https://developer.apple.com/documentation/devicecheck/attestation-object-validation-guide#Walking-through-the-validation-steps
    public static func validate(attestation: AttestationObject) throws {
        let certificates = try attestation.statement
            .certificateChain
            .map(Certificate.init)
        // 1. Verify that the x5c array contains the intermediate and leaf certificates for App Attest
        // a) Intermediate certificate

        // b) Leaf certificate

    }
}
