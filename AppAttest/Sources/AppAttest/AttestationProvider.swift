import DeviceCheck

protocol AttestationProvider {
    var isSupported: Bool { get }

    func generateKey() async throws -> String

    func attestKey(
        _: String,
        clientDataHash: Data
    ) async throws -> Data
}

extension DCAppAttestService: AttestationProvider { }
