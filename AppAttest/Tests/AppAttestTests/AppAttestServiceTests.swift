@testable import AppAttest
import Testing

struct AppAttestServiceTests {
    let attestationProvider: MockAttestationProvider
    let sut: AppAttestService

    init() {
        attestationProvider = MockAttestationProvider()
        sut = AppAttestService(
            attestationProvider: attestationProvider
        )
    }

    @Test("Throws error if device is unsupported")
    func unsupportedDevice() async {
        attestationProvider.isSupported = false

        await #expect(throws: AppAttestServiceError.unsupportedDevice) {
            try await sut.fetchAttestation()
        }
    }

    @Test("Generates key if device is supported")
    func supportedDeviceGeneratesKey() async throws {
        attestationProvider.isSupported = true

        try await  sut.fetchAttestation()
        #expect(attestationProvider.didGenerateKey)
    }

}
