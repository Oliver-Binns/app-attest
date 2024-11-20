import Foundation

public protocol AttestationObject {
    associatedtype Data: AuthenticatorData
    associatedtype Statement: AttestationStatement

    var format: String { get }
    var authenticatorData: Data { get }
    var statement: Statement { get }
}
