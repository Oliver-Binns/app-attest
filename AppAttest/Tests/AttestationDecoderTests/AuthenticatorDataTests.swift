@testable import AttestationDecoder
import Foundation
import Testing

struct AuthenticatorDataTests {
    var authenticatorData: Data {
        get throws {
            try #require(Data(base64Encoded: """
            CVqj6oy4szHiiDd8cYbSvfsW9hVM3M8PUt8FUQyaY2xAAAAAAGFwcGF0dGVzdGRldmVsb3A
            AIH1Cj/hcabcKPp9XXIa/WOX0V6E2eg8/GurzszVtNzdSpQECAyYgASFYIECvB8wEheNQFz
            Zl1SCINwg7rYImcdOd7JXaIXypG14ZIlggqzfw6JMMwuDa1jV6px5GFRJF6DY2PzBKpkHwJ
            j82/fM=
            """.filter { !$0.isWhitespace }))
        }
    }

    @Test("Authenticator Data correctly extracts the relying party hash")
    func rpIDHash() throws {
        let sut = try AuthenticatorData(
            rawValue: authenticatorData
        )
        #expect(
            sut.relyingPartyIDHash.base64EncodedString() ==
            "CVqj6oy4szHiiDd8cYbSvfsW9hVM3M8PUt8FUQyaY2w="
        )
    }
}
