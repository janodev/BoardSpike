import Foundation

public struct CardsResponse: Codable
{
    enum CodingKeys: String, CodingKey {
        case status = "STATUS"
        case column, people, cards
    }
    
    public let status: String?
    public let column: Column?
    public let people: [String: Person]?
    public let cards: [Card]?
}
