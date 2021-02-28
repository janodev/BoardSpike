import CoreData
import Foundation

@objc(ColumnMO)
public class ColumnMO: NSManagedObject, Persistable
{
    @NSManaged public var displayOrder: Int
    @NSManaged public var id: Int
    @NSManaged public var name: String
    @NSManaged public var projectId: Int
    @NSManaged public var sortOrder: String
    
    init(entity: NSEntityDescription,
         insertInto context: NSManagedObjectContext?,
         displayOrder: Int,
         id: Int,
         name: String,
         projectId: Int,
         sortOrder: String)
    {
        super.init(entity: entity, insertInto: context)
        self.displayOrder = displayOrder
        self.id = id
        self.name = name
        self.projectId = projectId
        self.sortOrder = sortOrder
    }
    
    // MARK: - Persistable
    
    public static var entityName = "ColumnMO"
}
