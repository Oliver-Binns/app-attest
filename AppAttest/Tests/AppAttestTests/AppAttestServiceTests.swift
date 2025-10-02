@testable import AppAttest
import CryptoKit
import DeviceCheck
import Testing

struct AppAttestServiceTests {
    let attestationProvider = MockAttestationProvider()
    let challengeProvider = MockChallengeProvider()
    let sut: AppAttestService

    init() {
        sut = AppAttestService(
            attestationProvider: attestationProvider
        )
    }

    @Test("Throws error if device is unsupported")
    func unsupportedDevice() async {
        attestationProvider.isSupported = false

        await #expect(throws: AppAttestServiceError.unsupportedDevice) {
            try await sut.fetchAttestation(challengeProvider: challengeProvider)
        }
    }

    @Test("Generates key if device is supported")
    func supportedDeviceGeneratesKey() async throws {
        attestationProvider.isSupported = true

        _ = try await sut.fetchAttestation(challengeProvider: challengeProvider)
        #expect(attestationProvider.didGenerateKey)
    }

    @Test("Fetch attestation throws error from generate key")
    func generatesKeyThrowsError() async throws {
        let error = DCError(.featureUnsupported)
        attestationProvider.generateKeyError = error

        await #expect(throws: error) {
            try await sut.fetchAttestation(challengeProvider: challengeProvider)
        }
    }

    @Test("Fetch attestation requests challenge")
    func fetchAttestationRequestsChallenge() async throws {
        _ = try await sut.fetchAttestation(challengeProvider: challengeProvider)

        #expect(challengeProvider.didRequestChallenge)
    }

    @Test("Key is attested with specified challenge (hashed) and key")
    func fetchAttestationAttestsKey() async throws {
        let attestationObject = try await sut.fetchAttestation(
            challengeProvider: challengeProvider
        )

        #expect(attestationProvider.didAttestKey)

        let challengeData = try await challengeProvider
            .challenge(for: String())

        let expectedChallenge = Data(
            SHA256.hash(data: challengeData)
        )
        #expect(attestationProvider.challengeUsedForAttest ==
                expectedChallenge)

        #expect(attestationObject == Data("attestation_object".utf8))
    }
}
