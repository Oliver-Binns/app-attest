@testable import AppAttestDemo
import Foundation
import Testing

@Suite(.serialized)
struct RemoteChallengeProviderTests {
    private let sut = RemoteChallengeProvider(
        session: URLSession(configuration: .mock)
    )

    @Test("Makes correctly formatted request to remote endpoint")
    func makeRequest() async throws {
        let url = try #require(URL(string: "http://localhost:8080/challenge"))
        let keyID = UUID().uuidString
        MockURLProtocol.queueResponse(
            (data: Data(), response: URLResponse()),
            to: url
        )

        _ = try? await sut.challenge(for: keyID)

        #expect(MockURLProtocol.requests.count == 1)

        let request = try #require(MockURLProtocol.requests.first)
        #expect(request.url == url)
        #expect(request.httpMethod == "POST")
        #expect(request.allHTTPHeaderFields == [
            "Content-Type": "application/json",
            "Content-Length": "48"
        ])

        let body = try #require(
            request.bodyStreamAsJSON() as? [String: String]
        )
        #expect(body == ["keyID": keyID])
    }

    @Test("Decodes response from remote endpoint")
    func decodeResponse() async throws {
        let url = try #require(URL(string: "http://localhost:8080/challenge"))

        let expectedChallenge = Data(UUID().uuidString.utf8)
        let response = Data("""
        { "challenge" : "\(expectedChallenge.base64EncodedString())" }
        """.utf8)

        MockURLProtocol.queueResponse(
            (data: response, response: .success(url: url)),
            to: url
        )

        let challenge = try await sut.challenge(for: String())
        #expect(expectedChallenge == challenge)
    }
}

extension URLResponse {
    static func success(url: URL) -> HTTPURLResponse {
        HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
    }
}
