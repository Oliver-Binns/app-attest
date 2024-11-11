import Foundation
import Testing

extension Data {
    init(base64Encoded string: String) throws {
        self = try #require(
            Data(base64Encoded: string.filter { !$0.isWhitespace })
        )
    }
}
