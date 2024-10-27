import Foundation

public struct AttestationObject: Decodable {
    public let format: String

    enum CodingKeys: String, CodingKey {
        case format = "fmt"
    }
}
