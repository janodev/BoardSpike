import CoreData
import Foundation

@objc(CardMO)
public class CardMO: NSManagedObject, Persistable
{
    @NSManaged public var id: Int
    @NSManaged public var columnId: Int
    @NSManaged public var name: String
    @NSManaged public var assignedPeople: [PersonMO]
    @NSManaged public var tags: [TagMO]

    init(entity: NSEntityDescription,
         insertInto context: NSManagedObjectContext?,
         id: Int,
         columnId: Int,
         name: String,
         assignedPeople: [PersonMO],
         tags: [TagMO])
    {
        super.init(entity: entity, insertInto: context)
        self.id = id
        self.columnId = columnId
        self.name = name
        self.assignedPeople = assignedPeople
        self.tags = tags
    }
    
    // MARK: - Persistable
    
    public static var entityName = "CardMO"
}
