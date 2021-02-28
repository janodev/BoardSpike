
import Foundation

public struct CodableTag: Codable
{
    public let color: String
    public let id: Int
    public let name: String
    public let projectId: Int
    
    init(color: String,
         id: Int,
         name: String,
         projectId: Int)
    {
        self.color = color
        self.id = id
        self.name = name
        self.projectId = projectId
    }
}
