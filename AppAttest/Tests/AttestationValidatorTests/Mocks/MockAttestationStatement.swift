import AttestationValidator
import Foundation
import Testing

struct MockAttestationStatement: AttestationStatement {
    let certificateChain: [SecCertificate]
    let receipt: Data
}

extension AttestationStatement
where Self == MockAttestationStatement {
    static var valid: AttestationStatement {
        get throws {
            try MockAttestationStatement(
                certificateChain: [
                    .leaf,
                    .intermediate
                ],
                receipt: Data()
            )
        }
    }

    static var expired: AttestationStatement {
        get throws {
            try MockAttestationStatement(
                certificateChain: [
                    .leafExpired,
                    .intermediate
                ],
                receipt: Data()
            )
        }
    }

    static var empty: AttestationStatement {
        MockAttestationStatement(
            certificateChain: [],
            receipt: Data()
        )
    }
}
