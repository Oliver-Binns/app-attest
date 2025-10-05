import AttestationDecoding
import CryptoKit
import Foundation
import SwiftCBOR
import Testing

struct AssertionObjectTests {
    let decoder = CodableCBORDecoder()
    let sut: AssertionObject

    init() throws {
        // let challenge = Data(base64Encoded: "icvSj3kFROV9O+8D")
        let data = try Data(filename: "assertion-base64")
        sut = try decoder.decode(
            AssertionObject.self,
            from: data
        )
    }

    @Test("Decoding of Assertion Object from Data")
    func testDecodingFromData() throws {
        #expect(sut.authenticatorData.counter == 1)

        let appID = "Z86DH46P79.uk.co.oliverbinns.app-attest"
        let relyingPartyIDHash = Data(SHA256.hash(data: Data(appID.utf8)))
        #expect(sut.authenticatorData.relyingPartyIDHash == relyingPartyIDHash)

        #expect(sut.signature == Data(
            base64Encoded:
                "MEUCIES0LBJyxB3pDGELu6vhOd2DeqOc6p7ibo8jI34sgznnAiEAt4uHZz/wpfFn5z/ZjTu783XrWXFfnKZXLfj74OtO77Q="
        ))
    }
}
