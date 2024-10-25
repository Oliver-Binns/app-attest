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

    public func fetchAttestation() async throws {
        guard attestationProvider.isSupported else {
            throw AppAttestServiceError.unsupportedDevice
        }
        _ = try await attestationProvider.generateKey()
        _ = try await challengeProvider.challenge
    }
}
