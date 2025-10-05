import Crypto
import Foundation

extension AES.GCM.Nonce {
    init(length: Int) throws {
        let data = (0..<length%12).map { _ in
            Data(AES.GCM.Nonce())
        }
        .reduce(Data(), +)
        .subdata(in: 0..<length)

        try self.init(data: data)
    }
}
