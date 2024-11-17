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
    func challenge(for keyID: String) async throws -> Data {
        Data(AES.GCM.Nonce())
    }
}
