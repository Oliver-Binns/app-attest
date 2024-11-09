import AttestationValidator
import Foundation

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
                authenticatorData: Data(),
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
}
