import Foundation

public protocol AttestationStatement {
    var certificateChain: [SecCertificate] { get }
    var receipt: Data { get }
}
