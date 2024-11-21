@testable import AttestationDecoding
import Foundation
import Testing

struct AuthenticatorDataTests {
    @Test("Authenticator Data correctly extracts the relying party hash")
    func rpIDHash() throws {
        let data = try Data(filename: "authenticator-data-valid")
        let sut = AuthenticatorData(rawValue: data)
        #expect(
            sut.relyingPartyIDHash.base64EncodedString() ==
            "CVqj6oy4szHiiDd8cYbSvfsW9hVM3M8PUt8FUQyaY2w="
        )
    }

    @Test("Authenticator Data correctly extracts the sign count")
    func signCount() throws {
        let unused = try AuthenticatorData(rawValue:
            Data(filename: "authenticator-data-valid")
        )
        #expect(unused.counter == 0)

        let largeCount = try AuthenticatorData(rawValue:
            Data(filename: "authenticator-data-used")
        )
        #expect(largeCount.counter == 272)
    }

    @Test("Authenticator Data correctly extracts the environment")
    func environment() throws {
        let development = try AuthenticatorData(rawValue:
            Data(filename: "authenticator-data-valid")
        )
        #expect(!development.isProduction)

        let production = try AuthenticatorData(rawValue:
            Data(filename: "authenticator-data-production")
        )
        #expect(production.isProduction)

        let unknown = try AuthenticatorData(rawValue:
            Data(filename: "authenticator-data-no-environment")
        )
        #expect(!unknown.isProduction)
    }

    @Test("Authenticator Data correctly extracts the key ID")
    func keyID() throws {
        let data = try Data(filename: "authenticator-data-valid")
        let sut = AuthenticatorData(rawValue: data)
        #expect(
            sut.credentialID ==
            "fUKP+Fxptwo+n1dchr9Y5fRXoTZ6Dz8a6vOzNW03N1I="
        )
    }
}
