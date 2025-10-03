@testable import AppAttest
import Foundation
import Testing

final class MockAttestationProvider: AttestationProvider {
    private let keyID = UUID().uuidString
    private(set) var didGenerateKey: Bool = false
    private(set) var didAttestKey: Bool = false
    private(set) var challengeUsedForAttest: Data?
    private(set) var didGenerateAssertion: Bool = false
    private(set) var challengeUsedForAssertion: Data?

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

    func generateAssertion(
        _ keyID: String,
        clientDataHash: Data
    ) async throws -> Data {
        didGenerateAssertion = true
        challengeUsedForAssertion = clientDataHash

        #expect(keyID == self.keyID)

        return Data("assertion_object".utf8)
    }
}
