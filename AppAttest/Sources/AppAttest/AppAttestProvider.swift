import Foundation

public protocol AppAttestProvider {
    func fetchAttestation() async throws -> Data
}
