import Foundation

public struct TasksResponse: Codable {
    public let status: String
    public let todoItems: [TodoItem]

    enum CodingKeys: String, CodingKey {
        case status = "STATUS"
        case todoItems = "todo-items"
    }
}
