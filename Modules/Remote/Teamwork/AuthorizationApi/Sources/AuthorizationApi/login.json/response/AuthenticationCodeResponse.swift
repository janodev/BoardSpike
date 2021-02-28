
import Foundation

public struct AuthenticationCodeResponse: Codable
{
    public let app: App
    public let code: String
    public let gdprSeen: Bool
    public let installation: Installation
    public let status: String
    public let userID: Int
    public let usernameInfo: UsernameInfo

    public enum CodingKeys: String, CodingKey {
        case app
        case code
        case gdprSeen
        case installation
        case status
        case userID = "userId"
        case usernameInfo
    }
}
