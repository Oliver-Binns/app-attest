import Foundation

public final class MockURLProtocol: URLProtocol {
    public private(set) static var requests: [URLRequest] = []
    private static var responses: [ URL: (data: Data, response: URLResponse) ] = [:]

    public static func queueResponse(
        _ response: (data: Data, response: URLResponse),
        to url: URL
    ) {
        responses[url] = response
    }

    public static func clear() {
        requests = []
        responses = [:]
    }

    public override static func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    public override static func canInit(with request: URLRequest) -> Bool {
        requests.append(request)
        return true
    }

    public override func startLoading() {
        if let url = self.request.url,
           let response = MockURLProtocol.responses[url] {
            client?.urlProtocol(self, didReceive: response.response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: response.data)
        } else {
            fatalError("No response queued for request \(request)")
        }
        client?.urlProtocolDidFinishLoading(self)
    }

    public override func stopLoading() {
        // This method is unused in the mock currently
    }
}

extension URLSessionConfiguration {
    static var mock: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return configuration
    }
}
