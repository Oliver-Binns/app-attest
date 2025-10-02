import Foundation

extension BackendIntegrationService {
    func attest(keyID: String, _ attestation: Data) async throws {
        let (data, response) = try await session
            .data(for: .attest(
                keyID: keyID,
                attestation: attestation
            ))

    }
}
