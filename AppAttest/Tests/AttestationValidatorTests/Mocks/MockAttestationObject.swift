import AttestationValidator
import Foundation
import Testing

struct MockAttestationObject: AttestationObject {
    let format: String
    let authenticatorData: AuthenticatorData
    let statement: AttestationStatement
}

extension AttestationObject
where Self == MockAttestationObject {
    static var valid: AttestationObject {
        get throws {
            try MockAttestationObject(
                format: "apple-appattest",
                authenticatorData: .valid,
                statement: .valid
            )
        }
    }

    static var expired: AttestationObject {
        get throws {
            try MockAttestationObject(
                format: "apple-appattest",
                authenticatorData: .valid,
                statement: .expired
            )
        }
    }
}
