import Foundation

public protocol AttestationObject {
    var format: String { get }
    var authenticatorData: Data { get }
    var statement: AttestationStatement { get }
}