import AttestationValidation
import Foundation
import Testing

struct MockAttestationObject: AttestationObject {
    let format: String
    let authenticatorData: MockAuthenticatorData
    let statement: MockAttestationStatement
}

extension AttestationObject
where Self == MockAttestationObject {
    static var valid: any AttestationObject {
        get throws {
            try MockAttestationObject(
                format: "apple-appattest",
                authenticatorData: .valid,
                statement: .valid
            )
        }
    }

    static var expired: any AttestationObject {
        get throws {
            try MockAttestationObject(
                format: "apple-appattest",
                authenticatorData: .valid,
                statement: .expired
            )
        }
    }
}
