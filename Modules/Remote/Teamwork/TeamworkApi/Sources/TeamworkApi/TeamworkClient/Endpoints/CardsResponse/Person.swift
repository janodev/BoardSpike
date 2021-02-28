import Foundation

public struct Person: Codable
{
    enum CodingKeys: String, CodingKey {
        case firstName, fullName, lastName, name
        case id
        case avatarURL = "avatarUrl"
    }
    
    public let id: String?
    public let firstName, fullName, lastName, name: String?
    public let avatarURL: String?
}
