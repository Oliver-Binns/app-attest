public protocol AppAttestProvider {
    func fetchAttestation() async throws
}
