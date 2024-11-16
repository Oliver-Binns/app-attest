import Foundation

public protocol ChallengeProvider {
    func challenge(for keyID: String) async throws -> Data
}
