
import Foundation

public struct CodablePerson: Codable
{
    public let id: Int
    public let name: String
    public let company: CodableCompany
    public let avatarUrl: URL
    public let firstName: String
    public let lastName: String
    
    init(id: Int,
         name: String,
         company: CodableCompany,
         avatarUrl: URL,
         firstName: String,
         lastName: String)
    {
        self.id = id
        self.name = name
        self.company = company
        self.avatarUrl = avatarUrl
        self.firstName = firstName
        self.lastName = lastName
    }
}
