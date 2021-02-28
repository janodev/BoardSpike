import Foundation

public struct Credentials
{
    public let accessToken: String
    public let apiEndPoint: String

    public init(accessToken: String, apiEndPoint: String) {
        self.accessToken = accessToken
        self.apiEndPoint = apiEndPoint
    }
}
