public struct Installation: Codable
{
    public let apiEndPoint: String
    public let chatEnabled: Bool
    public let company: Company
    public let deskEnabled: Bool
    public let id: Int
    public let logo: String
    public let name: String
    public let projectsEnabled: Bool
    public let region: String
    public let url: String
}
