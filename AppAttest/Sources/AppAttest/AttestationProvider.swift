import DeviceCheck

protocol AttestationProvider {
    var isSupported: Bool { get }
    func generateKey() async throws -> String
}

extension DCAppAttestService: AttestationProvider { }
