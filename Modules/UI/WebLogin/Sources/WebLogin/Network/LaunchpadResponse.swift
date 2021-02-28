import Foundation

public struct Company: Codable
{
    public let id: Int
    public let name: String
    public let logo: String
}

public struct Installation: Codable
{
    public let id: Int
    public let name: String
    public let region: String
    public let apiEndPoint: String
    public let url: String
    public let chatEnabled: Bool
    public let company: Company
    public let logo: String
}

public struct User: Codable
{
    public let id: Int
    public let firstName: String
    public let lastName: String
    public let email: String
    public let avatar: String
    public let company: Company
}

public struct LaunchpadResponse: Codable
{
    public let accessToken: String
    public let installation: Installation
    public let status: String
    public let user: User
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case installation
        case status
        case user
    }
}
