import Foundation

public final class Task: NSObject, Codable
{
    static let taskUTI = "projects.board.task"
    
    public let title: String
    public let tags: [String]
    
    public init(title: String = "", tags: [String] = [])
    {
        self.title = title
        self.tags = tags
    }
}

public extension Task {
    
    override var description: String {
        
        let tagsDescription = tags.joined(separator: ", ")
        return "title=\(title), tags=[ \(tagsDescription) ]"
    }
}

extension Task: NSItemProviderWriting
{
    public static var writableTypeIdentifiersForItemProvider = [taskUTI]
    
    public func loadData(
        withTypeIdentifier typeid: String,
        forItemProviderCompletionHandler completion: @escaping (Data?, Error?) -> Void) -> Progress?
    {
        guard typeid == Task.taskUTI else
        {
            completion(nil, DragAndDropError.wrongUTI)
            return nil
        }
        do {
            completion(try PropertyListEncoder().encode(self), nil)
        } catch {
            completion(nil, DragAndDropError.serializationError(error))
        }
        return nil /* conversion is instant */
    }
}
 
extension Task: NSItemProviderReading
{
    public static var readableTypeIdentifiersForItemProvider = [taskUTI]
        
    public static func object(withItemProviderData data: Data, typeIdentifier typeid: String) throws -> Self
    {
        guard typeid == Task.taskUTI else { throw DragAndDropError.wrongUTI }
        do {
            return try PropertyListDecoder().decode(self, from: data)
        } catch {
            throw DragAndDropError.deserializationError(error)
        }
    }
}
