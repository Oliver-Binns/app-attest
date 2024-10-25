import AppAttest
import Foundation
import Testing

final class MockChallengeProvider: ChallengeProvider {
    private(set) var didRequestChallenge = false

    var challenge: Data {
        get throws {
            didRequestChallenge = true
            return Data("abc123".utf8)
        }
    }
}
