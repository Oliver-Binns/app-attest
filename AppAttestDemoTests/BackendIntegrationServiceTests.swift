@testable import AppAttestDemo
import Foundation
import Testing

@Suite(.serialized)
final class BackendIntegrationServiceTests {
    private let sut = BackendIntegrationService(
        session: URLSession(configuration: .mock)
    )

    @Test("Makes correctly formatted request to remote endpoint")
    func makeRequestToFetchChallenge() async throws {
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

    @Test("Decodes response from request challenge endpoint")
    func decodeResponseFromFetchChallenge() async throws {
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

    @Test("Makes correctly formatted request to submit attestation")
    func makeRequestToVerifyAttestation() async throws {
        let url = try #require(URL(string: "http://localhost:8080/verify"))
        MockURLProtocol.queueResponse(
            (data: Data(), response: URLResponse()),
            to: url
        )

        let keyID = UUID().uuidString
        let attestation = Data("mock_attestation".utf8)

        _ = try await sut.attest(keyID: keyID, attestation)

        #expect(MockURLProtocol.requests.count == 1)

        let request = try #require(MockURLProtocol.requests.first)
        #expect(request.url == url)
        #expect(request.httpMethod == "POST")
        #expect(request.allHTTPHeaderFields == [
            "Content-Type": "application/json",
            "Content-Length": "89"
        ])

        let body = try #require(
            request.bodyStreamAsJSON() as? [String: String]
        )
        #expect(body == [
            "keyID": keyID,
            "attestation": attestation.base64EncodedString()
        ])
    }

    deinit {
        MockURLProtocol.clear()
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
