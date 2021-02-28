
import os.log
import UIKit

public protocol Coordinator: AnyObject, CustomStringConvertible, CustomDebugStringConvertible
{
    var parent: Coordinator? { get }
    var children: [Coordinator] { get set }
    func add(_ coordinator: Coordinator)
    func remove(_ coordinator: Coordinator)
    func start()
    func finish()
}

public extension Coordinator
{
    func finish() {
        parent?.remove(self)
    }

    func add(_ child: Coordinator) {
        children.append(child)
        child.start()
    }
    
    func remove(_ child: Coordinator) {
        if let index = children.lastIndex(where: { $0 === child }) {
            children.remove(at: index)
        }
    }

    // MARK: - CustomDebugStringConvertible
    
    var debugDescription: String {
        let name = "\"name\": \"\(type(of: self))\""
        let childrenDescription = children.isEmpty ? "" : children.map { $0.debugDescription }.joined(separator: ",")
        let parentDescription = parent.map { "\"parent\": { \($0.description) }" } ?? ""
        let json = [name, parentDescription, childrenDescription].filter { !$0.isEmpty }.joined(separator: ",")
        return "{ \(json) }"
    }
    
    // MARK: - CustomStringConvertible
    
    var description: String {
        String(cString: class_getName(type(of: self)))
    }
}
