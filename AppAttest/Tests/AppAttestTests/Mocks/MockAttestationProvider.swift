@testable import AppAttest

final class MockAttestationProvider: AttestationProvider {
    var isSupported: Bool = true
}
