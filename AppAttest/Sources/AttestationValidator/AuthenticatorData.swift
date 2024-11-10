import Foundation

public protocol AuthenticatorData {
    var rawValue: Data { get }
    var relyingPartyIDHash: Data { get }
}
