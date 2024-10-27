import AttestationDecoder
import CBORCoding
import Foundation
import Testing

struct AttestationObjectTests {
    let decoder = CBORDecoder()
    let sut: AttestationObject

    init() throws {
        let url = try #require(Bundle.module.url(
            forResource: "attest-base64",
            withExtension: "txt"
        ))
        let fileContents = try Data(contentsOf: url)
        let string = try #require(String(data: fileContents, encoding: .utf8))
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let data = try #require(
            Data(base64Encoded: string)
        )

        sut = try decoder.decode(
            AttestationObject.self .self,
            from: data
        )
    }

    @Test("Decoding of Attestation Object from Data")
    func testDecodingFromData() throws {
        #expect(sut.format == "apple-appattest")
    }
}
