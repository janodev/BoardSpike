import CoreData

struct ModelFactory
{
    func model() -> NSManagedObjectModel
    {
        // MARK: - Attributes
        
        let avatarUrl = uriAttribute("avatarUrl")
        let color = stringAttribute("color")
        let columnId = int64Attribute("columnId")
        let displayOrder = int64Attribute("displayOrder")
        let firstName = stringAttribute("firstName")
        let id = int64Attribute("id")
        let lastName = stringAttribute("lastName")
        let name = stringAttribute("name")
        let projectId = int64Attribute("projectId")
        let sortOrder = stringAttribute("sortOrder")
        
        // MARK: - Entities
        
        let cardEntity = entity("Card", CardMO.self)
        let columnEntity = entity("Column", ColumnMO.self)
        let companyEntity = entity("Company", CompanyMO.self)
        let personEntity = entity("Person", PersonMO.self)
        let projectEntity = entity("Project", ProjectMO.self)
        let tagEntity = entity("Tag", TagMO.self)
        
        // MARK: - Relations
        
        let assignedPeople = relation("assignedPeople", personEntity, .nullifyDeleteRule)
        let tags = relation("tags", tagEntity, .nullifyDeleteRule)
        let company = relation("company", companyEntity, .nullifyDeleteRule)
        
        // MARK: - Properties
        
        cardEntity.properties    = [id, name, assignedPeople, columnId, tags]
        columnEntity.properties  = [id, name, displayOrder, projectId, sortOrder]
        companyEntity.properties = [id, name]
        personEntity.properties  = [id, name, avatarUrl, company, firstName, lastName]
        projectEntity.properties = [id, name]
        tagEntity.properties     = [id, name, color, projectId]
        
        // MARK: - Model
        
        let model = NSManagedObjectModel()
        model.entities = [
            cardEntity,
            columnEntity,
            companyEntity,
            personEntity,
            projectEntity,
            tagEntity
        ]
        
        return model
    }
    
    // MARK: - Private
    
    private func stringAttribute(_ name: String) -> NSAttributeDescription {
        attribute(name, .stringAttributeType)
    }
    private func int64Attribute(_ name: String) -> NSAttributeDescription {
        attribute(name, .integer64AttributeType)
    }
    private func uriAttribute(_ name: String) -> NSAttributeDescription {
        attribute(name, .URIAttributeType)
    }
    private func attribute(_ name: String, _ type: NSAttributeType) -> NSAttributeDescription {
        let attribute = NSAttributeDescription()
        attribute.name = name
        attribute.attributeType = type
        return attribute
    }
    
    private func entity(_ name: String, _ anyClass: AnyClass) -> NSEntityDescription {
        let entity = NSEntityDescription()
        entity.name = name
        entity.managedObjectClassName = NSStringFromClass(anyClass)
        return entity
    }
    
    private func relation(_ name: String,
                          _ destination: NSEntityDescription,
                          _ deleteRule: NSDeleteRule) -> NSRelationshipDescription {
        let relation = NSRelationshipDescription()
        relation.name = name
        relation.destinationEntity = destination
        relation.deleteRule = deleteRule
        return relation
    }
}
