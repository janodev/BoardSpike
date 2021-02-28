
import CoreData
import Foundation

/// A Core Data stack if you fancy a simplified setup.
class CoreDataContainerStack
{
    private let modelName: String
    private let model: NSManagedObjectModel
    
    init(modelName: String = "Model", model: NSManagedObjectModel) {
        self.modelName = modelName
        self.model = model
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName, managedObjectModel: model)
        container.loadPersistentStores { description, error in
            log.debug("\(description)")
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
}
