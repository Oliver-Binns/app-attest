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
    func unsupportedDevice() {
        attestationProvider.isSupported = false

        #expect(throws: AppAttestServiceError.unsupportedDevice) {
            try sut.fetchAttestation()
        }
    }
}
