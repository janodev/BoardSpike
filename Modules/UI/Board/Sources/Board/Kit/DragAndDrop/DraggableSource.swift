import Foundation
import os

/// Source of data for drag and drop views.
protocol DraggableSource: AnyObject, Hashable {
    
    associatedtype Item: Hashable, NSItemProviderReading, NSItemProviderWriting
    
    var count: Int { get }
    var items: [Item] { get set }

    func append(_ elements: [Item])
    func append(_ item: Item)
    func insert(_ item: Item, at otherItem: Item)
    func insert(_ item: Item, at row: Int)
    func item(at row: Int) -> Item
    func moveItem(_ identifier: Item, afterItem toIdentifier: Item)
    func moveItem(_ identifier: Item, beforeItem toIdentifier: Item)
    func remove(at row: Int)
    func remove(_ elements: [Item])
    func remove(_ item: Item)
    func row(for item: Item) -> Int
    func rows(for items: [Item]) -> [Int]
}

extension DraggableSource
{
    // MARK: - Collection
    
    var count: Int {
        log.debug("source.count: \(items.count)")
        return items.count
    }
    
    func remove(at row: Int)
    {
        log.debug("source.remove(at:\(row))")
        items.remove(at: row)
    }
    
    func remove(_ item: Item)
    {
        log.debug("source.remove(\(item))")
        items.remove(at: row(for: item))
    }

    func remove(_ elements: [Item])
    {
        log.debug("source.remove(\(elements))")
        elements.forEach {
            items.remove(at: row(for: $0))
        }
    }
    
    // insert item before item
    func insert(_ item: Item, at otherItem: Item)
    {
        log.debug("source.insert(\(item), at: \(otherItem))")
        items.insert(item, at: row(for: otherItem))
    }
    
    func insert(_ item: Item, at row: Int)
    {
        log.debug("source.insert(\(item), at: \(row))")
        items.insert(item, at: row)
        log.debug("source.items is now \(items)")
    }
    
    func append(_ item: Item)
    {
        log.debug("source.append(\(item))")
        items.append(item)
    }
    
    func append(_ elements: [Item])
    {
        log.debug("source.append(\(elements))")
        elements.forEach { items.append($0) }
    }
    
    func item(at row: Int) -> Item
    {
        log.debug("source.item(at: \(row)) -> \(items[row])")
        return items[row]
    }
    
    func row(for item: Item) -> Int
    {
        let index = items.firstIndex { $0 == item }
        if index == nil { log.error("> 🚨 No index for such item. Crashing.") }
        log.debug("source.row for \(item) is \(row as Any)")
        // swiftlint:disable force_unwrapping
        return index!
    }
    
    func rows(for items: [Item]) -> [Int]
    {
        items.compactMap { row(for: $0) }
    }
    
    func moveItem(_ identifier: Item, beforeItem toIdentifier: Item)
    {
        remove(identifier)
        insert(identifier, at: row(for: toIdentifier))
    }

    func moveItem(_ identifier: Item, afterItem toIdentifier: Item)
    {
        remove(identifier)
        insert(identifier, at: (row(for: toIdentifier) + 1))
    }
}
