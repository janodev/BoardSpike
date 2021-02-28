import Foundation

public struct ProjectsResponse: Codable {
    public let status: String?
    public let projects: [Project]?

    enum CodingKeys: String, CodingKey {
        case status = "STATUS"
        case projects
    }
}
