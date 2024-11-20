import AttestationValidation
import Foundation
import X509
import Testing

struct MockAttestationStatement: AttestationStatement {
    let certificateChain: [Certificate]
    let receipt: Data
}

extension AttestationStatement
where Self == MockAttestationStatement {
    static var valid: MockAttestationStatement {
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

    static var expired: MockAttestationStatement {
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

    static var empty: MockAttestationStatement {
        MockAttestationStatement(
            certificateChain: [],
            receipt: Data()
        )
    }
}
