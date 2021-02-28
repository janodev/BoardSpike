import CoreData

public protocol Persistable: NSManagedObject
{
    static var entityName: String { get }
}
