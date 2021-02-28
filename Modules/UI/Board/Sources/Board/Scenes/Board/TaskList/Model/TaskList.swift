import Foundation
import os

/// List of tasks.
public final class TaskList
{
    /// Identifier 
    public var id: Int
    
    /// Title of the task list
    public var title: String
    
    /// Tasks
    public var tasks: [Task]

    /// Initializer.
    /// - Parameter title: Title of the task list
    public convenience init(id: Int, title: String)
    {
        self.init(id: id, title: title, tasks: [])
    }

    /// Initializer.
    /// - Parameters:
    ///   - title: Title of the task list
    ///   - items: Tasks in the list
    public init(id: Int, title: String, tasks: [Task])
    {
        self.id = id
        self.title = title
        self.tasks = tasks
    }
}

extension TaskList: CustomStringConvertible
{
    public var description: String
    {
        let tasksDescription = tasks.map { "\n\t\t" + $0.description }.joined(separator: ", ")
        return "title=\(title), \n\ttasks=[ \(tasksDescription) \n\t]"
    }
}

extension TaskList: Equatable
{
    public static func == (lhs: TaskList, rhs: TaskList) -> Bool
    {
        lhs.title == rhs.title && lhs.tasks.elementsEqual(rhs.tasks)
    }
}

extension TaskList: Hashable
{
    public func hash(into hasher: inout Hasher)
    {
        hasher.combine(title)
        hasher.combine(tasks)
    }
}

extension TaskList: DraggableSource {

    // MARK: - Collection
    
    var items: [Task] {
        get { tasks }
        set { tasks = newValue }
    }
}
