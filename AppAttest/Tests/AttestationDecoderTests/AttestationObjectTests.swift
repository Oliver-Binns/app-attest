import AttestationDecoder
import SwiftCBOR
import Foundation
import Testing

struct AttestationObjectTests {
    let decoder = CodableCBORDecoder()
    let sut: AttestationObject

    init() throws {
        let data = try Data(filename: "attest-base64")
        sut = try decoder.decode(
            AttestationObject.self,
            from: data
        )
    }

    @Test("Decoding of Attestation Object from Data")
    func testDecodingFromData() throws {
        #expect(sut.format == "apple-appattest")

        #expect(sut.statement.certificateChain.count == 2)
        #expect(sut.authenticatorData.relyingPartyIDHash.base64EncodedString() ==
                "FVhAM8lQuf6dUUziohGjJtcaprEBSrTG+i+9qdmqGKY=")
    }
}
