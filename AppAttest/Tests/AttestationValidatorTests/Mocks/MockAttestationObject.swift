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
        MockAttestationObject(
            format: "",
            authenticatorData: Data(),
            statement: .valid
        )
    }
}
