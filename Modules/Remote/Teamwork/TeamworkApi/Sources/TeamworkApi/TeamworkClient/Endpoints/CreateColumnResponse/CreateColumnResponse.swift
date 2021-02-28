import Foundation

public struct CreateColumnResponse: Codable
{
    enum CodingKeys: String, CodingKey {
        case id
        case status = "STATUS"
    }
    
    public let id: String
    public let status: String
}
