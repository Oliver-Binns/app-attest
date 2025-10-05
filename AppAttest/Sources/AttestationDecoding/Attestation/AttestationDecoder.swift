import SwiftCBOR
import Foundation

public struct AttestationDecoder {
    let decoder: CodableCBORDecoder

    public init(decoder: CodableCBORDecoder = CodableCBORDecoder()) {
        self.decoder = decoder
    }

    public func decode(data: Data) throws -> AttestationObject {
        try decoder.decode(AttestationObject.self, from: data)
    }
}
