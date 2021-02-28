import CoreData
import Foundation

@objc(ProjectMO)
public class ProjectMO: NSManagedObject, Persistable
{
    @NSManaged public var id: Int
    @NSManaged public var name: String
    
    init(entity: NSEntityDescription,
         insertInto context: NSManagedObjectContext?,
         id: Int,
         name: String)
    {
        super.init(entity: entity, insertInto: context)
        self.id = id
        self.name = name
    }
    
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<ProjectMO> {
        NSFetchRequest<ProjectMO>(entityName: "ProjectMO")
    }
    
    // MARK: - Persistable
    
    public static var entityName = "ProjectMO"
}
