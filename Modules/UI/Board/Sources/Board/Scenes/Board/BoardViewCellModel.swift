
import Foundation

public final class BoardViewCellModel: NSObject
{
    public let onDragDidEnd: () -> Void
    public let onDragWillBegin: () -> Void
    public let taskList: TaskList
    
    public init(onDragDidEnd: @escaping () -> Void, onDragWillBegin: @escaping () -> Void, taskList: TaskList) {
        self.onDragDidEnd = onDragDidEnd
        self.onDragWillBegin = onDragWillBegin
        self.taskList = taskList
    }
}

extension BoardViewCellModel: NSItemProviderWriting
{
    public static var writableTypeIdentifiersForItemProvider = ["none"]
    
    // swiftlint:disable:next unavailable_function
    public func loadData(
        withTypeIdentifier typeid: String,
        forItemProviderCompletionHandler completion: @escaping (Data?, Error?) -> Void) -> Progress?
    {
        fatalError("not implemented")
    }
}
 
extension BoardViewCellModel: NSItemProviderReading
{
    public static var readableTypeIdentifiersForItemProvider = ["none"]
    
    // swiftlint:disable:next unavailable_function
    public static func object(withItemProviderData data: Data, typeIdentifier typeid: String) throws -> Self
    {
        fatalError("not implemented")
    }
}
