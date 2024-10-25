@testable import AppAttest
import DeviceCheck
import Testing

struct AppAttestServiceTests {
    let attestationProvider = MockAttestationProvider()
    let challengeProvider = MockChallengeProvider()
    let sut: AppAttestService

    init() {
        sut = AppAttestService(
            attestationProvider: attestationProvider,
            challengeProvider: challengeProvider
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

        try await sut.fetchAttestation()
        #expect(attestationProvider.didGenerateKey)
    }

    @Test("Fetch attestation throws error from generate key")
    func generatesKeyThrowsError() async throws {
        let error = DCError(.featureUnsupported)
        attestationProvider.generateKeyError = error

        await #expect(throws: error) {
            try await sut.fetchAttestation()
        }
    }

    @Test("Fetch attestation requests challenge")
    func fetchAttestationRequestsChallenge() async throws {
        try await sut.fetchAttestation()

        #expect(challengeProvider.didRequestChallenge)
    }
}
