
import Foundation

//protocol CRUD {
//    associatedtype ObjectType: Codable
//    func load(id: Int) -> ObjectType
//    func loadAll() -> [ObjectType]
//    func save(_ object: ObjectType)
//}

protocol Lock {
    func lock()
    func unlock()
}

final class Mutex: Lock
{
    private var mutex: pthread_mutex_t = {
        var mutex = pthread_mutex_t()
        pthread_mutex_init(&mutex, nil)
        return mutex
    }()
    func lock() {
        pthread_mutex_lock(&mutex)
    }
    func unlock() {
        pthread_mutex_unlock(&mutex)
    }
}

public class Database: NSObject, Codable
{
    private static let defaultsKey = "defaultsKey"
    
    private var _cards = [CodableCard]()
    private var _columns = [CodableColumn]()
    private var _companies = [CodableCompany]()
    private var _persons = [CodablePerson]()
    private var _projects = [CodableProject]()
    private var _tags = [CodableTag]()
    private let lock = Mutex()
    
    public enum CodingKeys: String, CodingKey
    {
        case _cards
        case _columns
        case _companies
        case _persons
        case _projects
        case _tags
    }
    
    public var cards: [CodableCard] {
        get {
            lock.lock()
            let value = _cards
            lock.unlock()
            return value
        }
        set {
            lock.lock()
            _cards = newValue
            save()
            lock.unlock()
        }
    }
    
    public var columns: [CodableColumn] {
        get {
            lock.lock()
            let value = _columns
            lock.unlock()
            return value
        }
        set {
            lock.lock()
            _columns = newValue
            save()
            lock.unlock()
        }
    }
    
    public var companies: [CodableCompany] {
        get {
            lock.lock()
            let value = _companies
            lock.unlock()
            return value
        }
        set {
            lock.lock()
            _companies = newValue
            save()
            lock.unlock()
        }
    }
    
    public var persons: [CodablePerson] {
        get {
            lock.lock()
            let value = _persons
            lock.unlock()
            return value
        }
        set {
            lock.lock()
            _persons = newValue
            save()
            lock.unlock()
        }
    }
    
    public var projects: [CodableProject] {
        get {
            lock.lock()
            let value = _projects
            lock.unlock()
            return value
        }
        set {
            lock.lock()
            _projects = newValue
            save()
            lock.unlock()
        }
    }
    
    public var tags: [CodableTag] {
        get {
            lock.lock()
            let value = _tags
            lock.unlock()
            return value
        }
        set {
            lock.lock()
            _tags = newValue
            save()
            lock.unlock()
        }
    }
    
    private func save()
    {
        do {
            let data = try JSONEncoder().encode(self)
            UserDefaults.standard.set(data, forKey: Database.defaultsKey)
        } catch {
            log.error("Error saving JSON. Skipping save. Error: \(error)")
        }
    }
    
    public static func read() -> Database
    {
        do {
            guard let data = UserDefaults.standard.data(forKey: Database.defaultsKey) else { return Database() }
            return try JSONDecoder().decode(Database.self, from: data)
        } catch {
            log.error("Error decoding JSON. Returning a new database. Error: \(error)")
        }
        return Database()
    }

    override public init() {}
    
    public init(cards: [CodableCard],
                columns: [CodableColumn],
                companies: [CodableCompany],
                persons: [CodablePerson],
                projects: [CodableProject],
                tags: [CodableTag])
    {
        super.init()
        self.cards = cards
        self.columns = columns
        self.companies = companies
        self.persons = persons
        self.projects = projects
        self.tags = tags
    }
}
