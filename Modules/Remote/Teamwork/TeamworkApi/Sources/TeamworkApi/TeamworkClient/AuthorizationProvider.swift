import Foundation

public protocol AuthorizationProviderProtocol {
    var authorizationHeader: [String: String] { get }
    var apiEndPoint: String { get }
}

public final class AuthorizationProvider: AuthorizationProviderProtocol
{
    public var authorizationHeader: [String: String]
    public let apiEndPoint: String

    public init(apiEndPoint: String, apiToken: String) {
        self.apiEndPoint = apiEndPoint
        let encodedApiKey = Data("\(apiToken):".utf8).base64EncodedString()
        self.authorizationHeader = ["Authorization": "BASIC \(encodedApiKey)"]
    }

    public init(apiEndPoint: String, accessToken: String) {
        self.apiEndPoint = apiEndPoint
        self.authorizationHeader = ["Authorization": "Bearer \(accessToken)"]
    }

    public init(apiEndPoint: String, authorizationHeader: [String: String]) {
        self.apiEndPoint = apiEndPoint
        self.authorizationHeader = authorizationHeader
    }
}
