@testable import AppAttest
import Foundation
import Testing

final class MockAttestationProvider: AttestationProvider {
    private let keyID = UUID().uuidString
    private(set) var didGenerateKey: Bool = false
    private(set) var didAttestKey: Bool = false
    private(set) var challengeUsedForAttest: Data?

    var isSupported: Bool = true
    var generateKeyError: Error?

    func generateKey() async throws -> String {
        didGenerateKey = true

        if let generateKeyError {
            throw generateKeyError
        }

        return keyID
    }

    func attestKey(
        _ keyID: String,
        clientDataHash: Data
    ) async throws -> Data {
        didAttestKey = true
        challengeUsedForAttest = clientDataHash

        #expect(keyID == self.keyID)

        return Data("attestation_object".utf8)
    }
}
