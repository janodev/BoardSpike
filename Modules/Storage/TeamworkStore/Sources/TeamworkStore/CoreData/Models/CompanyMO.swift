import CoreData
import Foundation

@objc(CompanyMO)
public class CompanyMO: NSManagedObject, Persistable
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
    
    // MARK: - Persistable
    
    public static var entityName = "CompanyMO"
}
