@testable import AttestationValidator
import Foundation
import Testing

struct AttestationValidatorTests {
    let sut: AttestationValidator

    init() throws {
        let components = DateComponents(
            year: 2024, month: 11, day: 01,
            hour: 12, minute: 0
        )

        let date = try #require(
            Calendar.current.date(from: components)
        )
        sut = AttestationValidator(validationDate: date)
    }

    @Test("Validate a valid attestation - throws no errors")
    func validateValidAttestation() async throws {
        try await sut.validate(attestation: .valid)
    }

    @Test("Validate an expired attestation - throws error")
    func validateExpiredAttestation() async throws {
        await #expect(throws: AttestationValidationError.invalidCertificateChain) {
            try await sut.validate(
                attestation: .expired
            )
        }
    }

    @Test("Validate an empty attestation - throws error")
    func validateIncorrectNumberOfCertificates() async throws {
        let attestation = MockAttestationObject(
            format: "apple-appattest",
            authenticatorData: Data(),
            statement: .empty
        )

        await #expect(throws: AttestationValidationError.invalidCertificateChain) {
            try await sut.validate(
                attestation: attestation
            )
        }
    }
}
