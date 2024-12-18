import CryptoKit
import Foundation

/// AuthenticatorData object as defined in the WebAuthn specification
/// https://developer.mozilla.org/en-US/docs/Web/API/Web_Authentication_API/Authenticator_data
///
/// This is an ArrayBuffer, at least 37 bytes in length, with the following fields:
/// Field Name | No. Bytes | Description
/// `rpIDHash` | 32 | SHA-256 hash of the relying party that the credential is scoped to (full App ID including Team ID)
/// `flags` | 1 | a number of boolean flags, including for whether the user is present
/// `signCount` | 4 |  A signature counter, if supported by the authenticator (set to 0 otherwise)
///
///
public struct AuthenticatorData: RawRepresentable {
    public let rawValue: Data

    public init(rawValue data: Data) {
        rawValue = data
    }

    public var relyingPartyIDHash: Data {
        rawValue[0..<32]
    }

    public var counter: Int {
        Int(data: rawValue[33..<37])
    }

    public var isProduction: Bool {
        Environment(bytes: rawValue[37..<53])
            == .production
    }

    var credentialIDLength: Int {
        Int(data: rawValue[53..<55])
    }

    public var credentialID: String {
        let endIndex = rawValue.index(55, offsetBy: credentialIDLength)
        return rawValue[55..<endIndex].base64EncodedString()
    }
}

extension AuthenticatorData: Decodable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.rawValue = try container.decode(Data.self)
    }
}
extension AuthenticatorData: Sendable { }
