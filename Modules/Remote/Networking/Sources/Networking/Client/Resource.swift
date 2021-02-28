import Foundation

public struct Resource: ExpressibleByStringLiteral
{
    public typealias StringLiteralType = String

    public enum HTTPMethod: String {
        case GET
        case POST
        case PUT
        case DELETE
    }

    let additionalHeaders: [String: String]
    let path: String
    let method: HTTPMethod
    let query: [String: String]
    let body: Data?

    public init(path: String,
                body: Data? = nil,
                additionalHeaders: [String: String] = [:],
                method: HTTPMethod = .GET,
                query: [String: String] = [:])
    {
        self.path = path
        self.body = body
        self.additionalHeaders = additionalHeaders
        self.method = method
        self.query = query
    }
    
    public init?(path: String,
                 body: [String: Any],
                 additionalHeaders: [String: String] = [:],
                 method: HTTPMethod = .GET,
                 query: [String: String] = [:])
    {
        guard let data = body.toJSONData() else { return nil }
        self.init(path: path,
                  body: data,
                  additionalHeaders: additionalHeaders,
                  method: method,
                  query: query)
    }

    // MARK: - ExpressibleByStringLiteral
    // This will let us use a string for path
    public init(stringLiteral value: StringLiteralType) {
        self.init(path: value)
    }
}
