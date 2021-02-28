import Foundation

public struct TodoItem: Codable
{
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case boardColumn = "boardColumn"
        case completed = "completed"
        case description = "description"
        case projectName = "project-name"
    }
    
    public let id: Int
    public let boardColumn: BoardColumn
    public let completed: Bool
    public let description: String
    public let projectName: String
    // ...
}
