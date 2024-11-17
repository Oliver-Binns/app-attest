import CryptoKit
import DeviceCheck

enum AppAttestServiceError: Error {
    case unsupportedDevice
}

public final class AppAttestService: AppAttestProvider {
    let attestationProvider: AttestationProvider
    let challengeProvider: ChallengeProvider

    init(
        attestationProvider: AttestationProvider,
        challengeProvider: ChallengeProvider
    ) {
        self.attestationProvider = attestationProvider
        self.challengeProvider = challengeProvider
    }

    public convenience init(challengeProvider: ChallengeProvider) {
        self.init(
            attestationProvider: DCAppAttestService.shared,
            challengeProvider: challengeProvider
        )
    }

    public func fetchAttestation() async throws -> Data {
        guard attestationProvider.isSupported else {
            throw AppAttestServiceError.unsupportedDevice
        }
        let keyID = try await attestationProvider.generateKey()
        let challenge = try await challengeProvider
            .challenge(for: keyID)
        let clientDataHash = Data(SHA256.hash(data: challenge))

        return try await attestationProvider.attestKey(
            keyID,
            clientDataHash: clientDataHash
        )
    }
}
