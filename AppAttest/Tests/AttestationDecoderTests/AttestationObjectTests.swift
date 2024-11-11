import AttestationDecoder
import CBORCoding
import Foundation
import Testing

struct AttestationObjectTests {
    let decoder = CBORDecoder()
    let sut: AttestationObject

    init() throws {
        let data = try Data(filename: "attest-base64")
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
