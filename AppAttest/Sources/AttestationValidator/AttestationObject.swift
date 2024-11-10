import Foundation

public protocol AttestationObject {
    var format: String { get }
    var authenticatorData: AuthenticatorData { get }
    var statement: AttestationStatement { get }
}
