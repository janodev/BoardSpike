import Foundation
@testable import Networking
import XCTest

struct Fish: Codable {
    let scales: Int
}

// swiftlint:disable force_try force_unwrapping
final class ApiClientTests: XCTestCase {

    static var allTests = [
        ("testApiClientRequest", testApiClientRequest)
    ]
    
    private let baseURL = URL(string: "https://domain.com/")!
    private let fish = Fish(scales: 3)
    private let fishURL = URL(string: "https://domain.com/fish.json")!
    private let path = "fish.json"
    
    func testApiClientRequest() {
        let apiClient = ApiClient(baseURL: baseURL, session: sessionStub(for: fish))
        let resource = Resource(path: path)
        let completion: (Result<Fish, RequestError>) -> Void = { result in
            guard case let Result.success(fish) = result else {
                XCTFail("Expected a Fish object")
                return
            }
            XCTAssertEqual(fish.scales, 3)
        }
        apiClient.request(resource: resource, completion: completion)
    }
    
    private func sessionStub<T: Encodable>(for encodable: T) -> SessionStub {
        let data = try! JSONEncoder().encode(encodable)
        let response = HTTPURLResponse(url: fishURL,
                                       statusCode: 200,
                                       httpVersion: "HTTP/1.1",
                                       headerFields: ["microweave": "fish"])
        return SessionStub(data: data,
                           response: response,
                           error: nil)
    }
}
