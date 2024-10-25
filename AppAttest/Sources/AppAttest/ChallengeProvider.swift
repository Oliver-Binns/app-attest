import Foundation

public protocol ChallengeProvider {
    var challenge: Data { get async throws }
}
