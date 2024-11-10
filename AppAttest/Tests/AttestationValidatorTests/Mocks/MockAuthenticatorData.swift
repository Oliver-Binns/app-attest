import AttestationValidator
import Foundation
import Testing

struct MockAuthenticatorData: AuthenticatorData {
    let rawValue: Data
    var relyingPartyIDHash: Data {
        rawValue.subdata(in: 0..<32)
    }
}

extension AuthenticatorData
where Self == MockAuthenticatorData {
    static var valid: AuthenticatorData {
        get throws {
            let raw = try #require(Data(base64Encoded: """
            CVqj6oy4szHiiDd8cYbSvfsW9hVM3M8PUt8FUQyaY2xAAAAAAGFwcGF0dGVzdGRldmVsb3A
            AIH1Cj/hcabcKPp9XXIa/WOX0V6E2eg8/GurzszVtNzdSpQECAyYgASFYIECvB8wEheNQFz
            Zl1SCINwg7rYImcdOd7JXaIXypG14ZIlggqzfw6JMMwuDa1jV6px5GFRJF6DY2PzBKpkHwJ
            j82/fM=
            """.filter { !$0.isWhitespace }))

            return MockAuthenticatorData(
                rawValue: raw
            )

        }
    }
}
