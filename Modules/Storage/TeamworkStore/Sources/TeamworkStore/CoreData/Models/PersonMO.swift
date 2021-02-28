import CoreData
import Foundation

@objc(PersonMO)
public class PersonMO: NSManagedObject, Persistable
{
    @NSManaged public var id: Int
    @NSManaged public var name: String
    @NSManaged public var company: CompanyMO
    @NSManaged public var avatarUrl: URL
    @NSManaged public var firstName: String
    @NSManaged public var lastName: String
    
    init(entity: NSEntityDescription,
         insertInto context: NSManagedObjectContext?,
         id: Int,
         name: String,
         company: CompanyMO,
         avatarUrl: URL,
         firstName: String,
         lastName: String)
    {
        super.init(entity: entity, insertInto: context)
        self.id = id
        self.name = name
        self.company = company
        self.avatarUrl = avatarUrl
        self.firstName = firstName
        self.lastName = lastName
    }
    
    // MARK: - Persistable
    
    public static var entityName = "PersonMO"
}
