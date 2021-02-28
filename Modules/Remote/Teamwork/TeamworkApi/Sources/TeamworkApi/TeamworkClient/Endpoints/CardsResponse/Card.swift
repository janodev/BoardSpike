import Foundation

public struct Card: Codable {
    public let columnID: String?
    public let name: String?
    public let assignedPeople: [String]?
    public let tags: [Tag]
    // ...
}
