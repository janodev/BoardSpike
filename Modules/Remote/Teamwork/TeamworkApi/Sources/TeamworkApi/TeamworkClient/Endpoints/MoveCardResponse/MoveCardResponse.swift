import Foundation

public struct MoveCardResponse: Codable {
    public let status: String
    
    enum CodingKeys: String, CodingKey {
        case status = "STATUS"
    }
}
