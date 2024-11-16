import AppAttest
import Foundation
import Testing

final class MockChallengeProvider: ChallengeProvider {
    private(set) var didRequestChallenge = false

    func challenge(for keyID: String) async throws -> Data {
        didRequestChallenge = true
        return Data("abc123".utf8)
    }
}
