import Foundation
import Testing

extension Data {
    init(filename: String) throws {
        let url = try #require(Bundle.module.url(
            forResource: filename,
            withExtension: "txt"
        ))
        let fileContents = try Data(contentsOf: url)
        let string = try #require(String(data: fileContents, encoding: .utf8))
            .trimmingCharacters(in: .whitespacesAndNewlines)
        self = try #require(
            Data(base64Encoded: string)
        )
    }
}
