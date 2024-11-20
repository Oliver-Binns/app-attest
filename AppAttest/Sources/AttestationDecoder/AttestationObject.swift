import Foundation

public struct AttestationObject {
    public let format: String
    public let authenticatorData: AuthenticatorData
    public let statement: AttestationStatement

}

extension AttestationObject: Decodable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.format = try container
            .decode(String.self, forKey: .format)

        let authenticatorData = try container
            .decode(Data.self, forKey: .authenticatorData)
        self.authenticatorData = AuthenticatorData(rawValue: authenticatorData)

        self.statement = try container
            .decode(AttestationStatement.self, forKey: .statement)
    }

    enum CodingKeys: String, CodingKey {
        case format = "fmt"
        case authenticatorData = "authData"
        case statement = "attStmt"
    }
}
