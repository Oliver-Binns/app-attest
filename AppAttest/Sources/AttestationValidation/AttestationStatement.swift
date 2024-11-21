import Foundation
import X509

public protocol AttestationStatement {
    var certificateChain: [Certificate] { get }
    var receipt: Data { get }
}
