import Foundation

public protocol AuthenticatorData {
    var rawValue: Data { get }
    var relyingPartyIDHash: Data { get }
    var counter: Int { get }
    var environment: AttestationEnvironment { get }
    var credentialID: String { get }
}

public enum AttestationEnvironment: Sendable {
    case development
    case production
}
