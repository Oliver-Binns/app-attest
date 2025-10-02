import CryptoKit
import DeviceCheck

enum AppAttestServiceError: Error {
    case unsupportedDevice
}

public final class AppAttestService: AppAttestProvider {
    let attestationProvider: AttestationProvider

    init(
        attestationProvider: AttestationProvider
    ) {
        self.attestationProvider = attestationProvider
    }

    public convenience init() {
        self.init(
            attestationProvider: DCAppAttestService.shared,
        )
    }

    public func fetchAttestation(challengeProvider: ChallengeProvider) async throws -> Data {
        guard attestationProvider.isSupported else {
            throw AppAttestServiceError.unsupportedDevice
        }
        let keyID = try await attestationProvider.generateKey()
        let challenge = try await challengeProvider.challenge(for: keyID)
        let clientDataHash = Data(SHA256.hash(data: challenge))

        return try await attestationProvider.attestKey(
            keyID,
            clientDataHash: clientDataHash
        )
    }

    public func fetchAssertion(keyID: String, challenge: Data) async throws -> Data {
        let clientDataHash = Data(SHA256.hash(data: challenge))
        return try await attestationProvider.generateAssertion(
            keyID,
            clientDataHash: clientDataHash
        )
    }
}
