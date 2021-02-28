
public struct App: Codable
{
    public let clientID: String
    public let code: String
    public let consentRequired: Bool
    public let dateCreated: String?
    public let dateUpdated: String?
    public let id: Int
    public let isValidated: Bool
    public let logo: String
    public let name: String
    public let ownerID: Int
    public let scope: [String]
    public let url: String

    public enum CodingKeys: String, CodingKey
    {
        case clientID = "clientId"
        case code
        case consentRequired
        case dateCreated
        case dateUpdated
        case id
        case isValidated
        case logo
        case name
        case ownerID = "ownerId"
        case scope
        case url
    }
}
