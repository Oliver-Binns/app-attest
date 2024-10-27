import Foundation

public struct AttestationObject: Decodable {
    public let format: String
    public let authenticatorData: Data
    public let statement: AttestationStatement

    enum CodingKeys: String, CodingKey {
        case format = "fmt"
        case authenticatorData = "authData"
        case statement = "attStmt"
    }
}
