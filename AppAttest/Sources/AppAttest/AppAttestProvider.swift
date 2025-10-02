import Foundation

public protocol AppAttestProvider {
    func fetchAttestation(challengeProvider: ChallengeProvider) async throws -> Data
}
