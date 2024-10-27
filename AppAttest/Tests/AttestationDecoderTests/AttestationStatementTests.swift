import AttestationDecoder
import Foundation
import Testing

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
                "Apple App Attestation CA 1")

        let leafCertificate = try #require(
            sut.certificateChain.first
        )
        #expect(try fetchName(from: leafCertificate) ==
                "Apple App Attestation CA 1")
    }

}

extension AttestationStatementTests {
    func fetchName(from certificate: SecCertificate) throws -> String {
        let values = try #require(
            SecCertificateCopyValues(
                certificate,
                nil,
                nil
            ) as? [String: Any]
        )

        let issuerName = try #require(
            values[kSecOIDX509V1IssuerName as String] as? [String: Any]
        )

        let nameComponents = try #require(
            issuerName["value"] as? NSArray
        )

        let first = try #require(nameComponents[0] as? [String: Any])
        return try #require(first["value"] as? String)
    }
}
