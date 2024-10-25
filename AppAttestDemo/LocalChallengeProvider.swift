import AppAttest
import CryptoKit
import Foundation

/// This type implements the ChallengeProvider protocol for demo purposes
/// In real world scenarios challenges should be provided and validated by your server
///
/// This implementation uses  a SHA256 hash of a unique, single-use 4-byte data block
/// Apple recommends that a 16-byte block should be used in real environments:
/// https://developer.apple.com/documentation/devicecheck/dcappattestservice/attestkey(_:clientdatahash:completionhandler:)
struct LocalChallengeProvider: ChallengeProvider {
    var challenge: Data {
        let uuid = UUID()
        let data = withUnsafePointer(to: uuid) {
            Data(bytes: $0, count: MemoryLayout.size(ofValue: uuid))
        }
        return Data(SHA256.hash(data: data))
    }
}
