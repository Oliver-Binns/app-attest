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
        self.init(attestationProvider: DCAppAttestService.shared)
    }

    public func fetchAttestation() async throws {
        guard attestationProvider.isSupported else {
            throw AppAttestServiceError.unsupportedDevice
        }
        _ = try await attestationProvider.generateKey()
    }
}
