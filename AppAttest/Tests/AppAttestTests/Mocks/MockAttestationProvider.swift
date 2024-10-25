@testable import AppAttest
import Foundation

final class MockAttestationProvider: AttestationProvider {
    let key = UUID().uuidString
    private(set) var didGenerateKey: Bool = false

    var isSupported: Bool = true

    func generateKey() async throws -> String {
        didGenerateKey = true
        return key
    }
}
