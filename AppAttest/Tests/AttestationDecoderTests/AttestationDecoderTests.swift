import AttestationDecoder
import Foundation
import Testing

struct AttestationDecoderTests {
    let sut = AttestationDecoder()

    @Test
    func testDecodingFromData() throws {
        let url = try #require(Bundle.module.url(
            forResource: "attest-base64",
            withExtension: "txt"
        ))
        let fileContents = try Data(contentsOf: url)
        let string = try #require(String(data: fileContents, encoding: .utf8))
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let data = try #require(Data(base64Encoded: string))

        let attestationObject = try sut.decode(data: data)
        #expect(attestationObject.format == "apple-appattest")
    }
}
