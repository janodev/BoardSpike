import CoreData

/// A Core Data stack if you fancy custom values.
class CoreDataCoordinatorStack
{
    private let filename: String
    private let model: NSManagedObjectModel

    init(filename: String = "Database.sql", model: NSManagedObjectModel) {
        self.filename = filename
        self.model = model
    }

    lazy var coordinator: NSPersistentStoreCoordinator = {
        let psc = NSPersistentStoreCoordinator(managedObjectModel: ModelFactory().model())
        let dirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        let fileURL = URL(string: dirURL!.absoluteString, relativeTo: dirURL)
        do {
            try psc.addPersistentStore(ofType: NSSQLiteStoreType,
                                       configurationName: nil,
                                       at: fileURL,
                                       options: nil)
        } catch {
            fatalError("Error configuring persistent store: \(error)")
        }
        return psc
    }()
    
    lazy var mainQueueContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        moc.persistentStoreCoordinator = coordinator
        return moc
    }()
}
