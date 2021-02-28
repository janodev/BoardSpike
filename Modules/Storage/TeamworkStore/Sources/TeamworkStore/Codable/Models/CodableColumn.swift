
import Foundation

public struct CodableColumn: Codable
{
    public let displayOrder: Int
    public let id: Int
    public let name: String
    public let projectId: Int
    public let sortOrder: String
    
    init(displayOrder: Int,
         id: Int,
         name: String,
         projectId: Int,
         sortOrder: String)
    {
        self.displayOrder = displayOrder
        self.id = id
        self.name = name
        self.projectId = projectId
        self.sortOrder = sortOrder
    }
}
