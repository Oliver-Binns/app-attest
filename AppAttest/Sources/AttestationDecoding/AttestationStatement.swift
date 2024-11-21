import X509
import Foundation

enum AttestationStatementDecodingError: Error {
    case invalidCertificateData
}

public struct AttestationStatement {
    /// A chain of certificates in x.509 format
    public let certificateChain: [Certificate]
    public let receipt: Data
}

extension AttestationStatement: Decodable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder
            .container(keyedBy: CodingKeys.self)

        self.receipt = try container.decode(Data.self, forKey: .receipt)
        self.certificateChain = try container.decode(
            [Data].self,
            forKey: .certificateChain
        ).map {
            guard let certificate = SecCertificateCreateWithData(nil, $0 as CFData) else {
                throw AttestationStatementDecodingError.invalidCertificateData
            }
            return certificate
        }.map(Certificate.init)
    }

    enum CodingKeys: String, CodingKey {
        case certificateChain = "x5c"
        case receipt
    }
}

extension AttestationStatement: Sendable { }
