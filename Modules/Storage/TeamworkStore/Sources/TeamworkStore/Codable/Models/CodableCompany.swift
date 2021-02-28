
import Foundation

public struct CodableCompany: Codable
{
    public let id: Int
    public let name: String
    
    init(id: Int,
         name: String)
    {
        self.id = id
        self.name = name
    }
}
