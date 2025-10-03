import Foundation

public protocol AppAttestProvider {
    func fetchAttestation(challengeProvider: ChallengeProvider) async throws -> Data
    func fetchAssertion(keyID: String, challenge: Data) async throws -> Data
}
