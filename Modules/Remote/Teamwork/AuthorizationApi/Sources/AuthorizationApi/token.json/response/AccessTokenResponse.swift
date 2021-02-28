import Foundation

public struct AccessTokenResponse: Codable
{
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case installation
        case status
        case user
    }
    public let accessToken: String
    public let installation: Installation
    public let status: String
    public let user: User
}
