import CBORCoding
import Foundation

public struct AttestationDecoder {
    let decoder: CBORDecoder

    public init(decoder: CBORDecoder = CBORDecoder()) {
        self.decoder = decoder
    }

    public func decode(data: Data) throws -> AttestationObject {
        try decoder.decode(from: data)
    }
}
