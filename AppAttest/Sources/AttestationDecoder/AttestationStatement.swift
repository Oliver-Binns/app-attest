import Foundation

public struct AttestationStatement: Decodable {
    /// A chain of certificates in x.509 format
    let certificateChain: [Data]
    let receipt: Data

    enum CodingKeys: String, CodingKey {
        case certificateChain = "x5c"
        case receipt
    }
}
