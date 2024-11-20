import AttestationDecoding
import Foundation
import Testing
import X509

struct AttestationStatementTests {
    let decoder = JSONDecoder()
    let sut: AttestationStatement

    init() throws {
        let url = try #require(Bundle.module.url(
            forResource: "attestation-statement",
            withExtension: "json"
        ))
        let fileContents = try Data(contentsOf: url)
        sut = try decoder.decode(
            AttestationStatement.self,
            from: fileContents
        )
    }

    @Test("Decoding of Certificate Chain")
    func testCertificateDecoding() async throws {
        #expect(sut.certificateChain.count == 2)

        let intermediateCertificate = try #require(sut.certificateChain.first)
        #expect(try fetchName(from: intermediateCertificate) ==
                "CN=Apple App Attestation CA 1")

        let leafCertificate = try #require(
            sut.certificateChain.first
        )
        #expect(try fetchName(from: leafCertificate) ==
                "CN=Apple App Attestation CA 1")
    }

}

extension AttestationStatementTests {
    func fetchName(from certificate: Certificate) throws -> String {
        let name = try #require(certificate.issuer.first)
        return name.description
    }
}
