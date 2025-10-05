import Foundation

public protocol AssertionObject {
    associatedtype Data: AuthenticatorData

    var authenticatorData: Data { get }
    var signature: Data { get }
}
