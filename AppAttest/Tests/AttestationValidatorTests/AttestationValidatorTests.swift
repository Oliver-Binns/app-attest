import AttestationValidator
import Testing

struct AttestationValidatorTests {
    @Test("Validate a valid attestation - throws no errors")
    func validate() async throws {
        try AttestationValidator.validate(attestation: .valid)
    }
}
