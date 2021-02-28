import CoreData
import Foundation

@objc(TagMO)
public class TagMO: NSManagedObject, Persistable
{
    @NSManaged public var color: String
    @NSManaged public var id: Int
    @NSManaged public var name: String
    @NSManaged public var projectId: Int
    
    init(entity: NSEntityDescription,
         insertInto context: NSManagedObjectContext?,
         color: String,
         id: Int,
         name: String,
         projectId: Int)
    {
        super.init(entity: entity, insertInto: context)
        self.color = color
        self.id = id
        self.name = name
        self.projectId = projectId
    }
    
    // MARK: - Persistable
    
    public static var entityName = "TagMO"
}
