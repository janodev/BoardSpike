import Foundation
@testable import Networking
import XCTest

// swiftlint:disable force_unwrapping
final class URLRequestResourceTests: XCTestCase {
    
    static var allTests = [
        ("testResource_init_String", testResource_init_String),
        ("testResource_init_Path", testResource_init_Path),
        ("testResource_init_PathBodyMethodQuery", testResource_init_PathBodyMethodQuery)
    ]
    
    private let baseURL = URL(string: "https://domain.com/")!
    private let path = "endpoint.json"
    private let query = ["a": "b c"]
    
    func testResource_init_String() {
        let resource = Resource(stringLiteral: path)
        let request = URLRequest(resource: resource, baseURL: baseURL)
        XCTAssertEqual(request?.httpMethod, Resource.HTTPMethod.GET.rawValue)
        XCTAssertEqual(request?.url?.absoluteString, "https://domain.com/endpoint.json")
    }
    
    func testResource_init_Path() {
        let resource = Resource(path: path)
        let request = URLRequest(resource: resource, baseURL: baseURL)
        XCTAssertEqual(request?.httpMethod, Resource.HTTPMethod.GET.rawValue)
        XCTAssertEqual(request?.url?.absoluteString, "https://domain.com/endpoint.json")
    }
    
    func testResource_init_PathBodyMethodQuery() {
        let resource = Resource(path: path,
                                httpBody: nil,
                                method: Resource.HTTPMethod.GET,
                                query: query)
        let url = URLRequest(resource: resource, baseURL: baseURL)
        XCTAssertEqual(url?.description, "https://domain.com/endpoint.json?a=b%20c")
    }
}
