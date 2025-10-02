import AppAttest
import Foundation

final class AttestationManager: ChallengeProvider {

    private let backendService: BackendIntegrationService
    private let appAttestProvider: AppAttestProvider
    private var keyID: String?

    init(
        appAttestProvider: AppAttestProvider = AppAttestService(),
        backendService: BackendIntegrationService = BackendIntegrationService()
    ) {
        self.backendService = backendService
        self.appAttestProvider = appAttestProvider
    }

    func challenge(for keyID: String) async throws -> Data {
        self.keyID = keyID
        return try await backendService.challenge(for: keyID)
    }

    func submitAttestation() async throws {
        let attestation = try await appAttestProvider
            .fetchAttestation(challengeProvider: self)

        guard let keyID else {
            fatalError("Attestation must have requested a challenge")
        }
        try await backendService.attest(keyID: keyID, attestation)
    }

    func getAssertion() async throws -> Data {
        guard let keyID else {
            fatalError("Key must ready have been attested before it can be asserted")
        }

        return try await appAttestProvider.fetchAssertion(
            keyID: keyID,
            challenge: challenge(for: keyID)
        )
    }
}
