import AttestationValidator
import Foundation
import Testing

struct MockAttestationObject: AttestationObject {
    let format: String
    let authenticatorData: Data
    let statement: AttestationStatement
}

extension AttestationObject
where Self == MockAttestationObject {
    static var valid: AttestationObject {
        get throws {
            try MockAttestationObject(
                format: "apple-appattest",
                authenticatorData: authenticatorData,
                statement: .valid
            )
        }
    }

    static var expired: AttestationObject {
        get throws {
            try MockAttestationObject(
                format: "apple-appattest",
                authenticatorData: Data(),
                statement: .expired
            )
        }
    }

    private static var authenticatorData: Data {
        get throws {
            try #require(Data(base64Encoded: """
            CVqj6oy4szHiiDd8cYbSvfsW9hVM3M8PUt8FUQyaY2xAAAAAAGFwcGF0dGVzdGRldmVsb3A
            AIH1Cj/hcabcKPp9XXIa/WOX0V6E2eg8/GurzszVtNzdSpQECAyYgASFYIECvB8wEheNQFz
            Zl1SCINwg7rYImcdOd7JXaIXypG14ZIlggqzfw6JMMwuDa1jV6px5GFRJF6DY2PzBKpkHwJ
            j82/fM=
            """.filter { !$0.isWhitespace }))
        }
    }
}
