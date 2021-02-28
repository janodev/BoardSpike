import CoreData

public class CRUD
{
    private let context: NSManagedObjectContext
    
    public init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    public func fetchRequest<P: Persistable>() -> NSFetchRequest<P> {
        NSFetchRequest<P>(entityName: P.entityName)
    }
    
    public func delete<P: Persistable>(_ object: P) {
        context.delete(object)
    }
    
    public func create<P: Persistable>() -> P? {
        guard
            let entity = NSEntityDescription.entity(forEntityName: P.entityName, in: context),
            let object = NSManagedObject(entity: entity, insertInto: context) as? P
        else {
            log.error("Could not create.")
            return nil
        }
        do {
            try context.save()
        } catch let error as NSError {
            log.error("Could not save. \(error), \(error.userInfo)")
        }
        return object
    }
    
    func fetchData<P: Persistable>() -> [P]
    {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: P.entityName)
        request.returnsObjectsAsFaults = false
        do {
            return try context.fetch(request) as? [P] ?? []
        } catch {
            print("Fetching data Failed")
        }
        return []
    }
}
