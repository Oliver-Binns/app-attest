@testable import AttestationValidator
import Foundation
import Testing

struct AttestationValidatorWrongAppTests {
    let sut: AttestationValidator

    init() throws {
        let components = DateComponents(
            year: 2024, month: 11, day: 10,
            hour: 12, minute: 0
        )

        let date = try #require(
            Calendar.current.date(from: components)
        )
        sut = AttestationValidator(
            appID: "Z86DH46P79.uk.co.oliverbinns.conferences",
            validationDate: date
        )
    }

    @Test("Correctly rejects AuthenticatorData from a different app")
    func mismatchingRelyingPartyID() async throws {
        let challenge = try #require(Data(base64Encoded: "QhTa7IcbW7LTtQyi"))

        await #expect(throws: AttestationValidationError.wrongRelyingParty) {
            try await sut.validate(
                attestation: .valid,
                challenge: challenge,
                keyID: "fUKP+Fxptwo+n1dchr9Y5fRXoTZ6Dz8a6vOzNW03N1I="
            )
        }
    }
}
