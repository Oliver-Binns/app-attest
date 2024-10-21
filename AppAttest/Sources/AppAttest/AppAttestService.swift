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

    func fetchAttestation() throws {
        guard attestationProvider.isSupported else {
            throw AppAttestServiceError.unsupportedDevice
        }
    }
}
