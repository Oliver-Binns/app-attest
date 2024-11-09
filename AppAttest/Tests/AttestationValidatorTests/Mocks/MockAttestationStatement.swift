import AttestationValidator
import Foundation

struct MockAttestationStatement: AttestationStatement {
    let certificateChain: [SecCertificate]
    let receipt: Data
}

extension AttestationStatement
where Self == MockAttestationStatement {
    static var valid: AttestationStatement {
        MockAttestationStatement(
            certificateChain: [],
            receipt: Data()
        )
    }
}
