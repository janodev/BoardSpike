
import Foundation

public struct CodableCard: Codable
{
    public let id: Int
    public let columnId: Int
    public let name: String
    public let assignedPeople: [CodablePerson]
    public let tags: [CodableTag]

    init(id: Int,
         columnId: Int,
         name: String,
         assignedPeople: [CodablePerson],
         tags: [CodableTag])
    {
        self.id = id
        self.columnId = columnId
        self.name = name
        self.assignedPeople = assignedPeople
        self.tags = tags
    }
}
