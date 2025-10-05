import Foundation

public struct AssertionObject {
    public let signature: Data
    public let authenticatorData: AuthenticatorData

}

extension AssertionObject: Decodable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.signature = try container
            .decode(Data.self, forKey: .signature)

        let authenticatorData = try container
            .decode(Data.self, forKey: .authenticatorData)
        self.authenticatorData = AuthenticatorData(rawValue: authenticatorData)
    }

    enum CodingKeys: String, CodingKey {
        case authenticatorData
        case signature
    }
}

extension AssertionObject: Sendable { }
