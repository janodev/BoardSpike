
import MobileCoreServices
import os
import UIKit

/// UICollectionView drop delegate.
final class CollectionDropDelegate<Source: DraggableSource>: NSObject & UICollectionViewDropDelegate
{
    private let source: Source
    private let collectionView: UICollectionView
    
    init(source: Source, collectionView: UICollectionView)
    {
        self.source = source
        self.collectionView = collectionView
    }
    
    // Indicates how this view reacts to drops.
    func collectionView(_ collectionView: UICollectionView,
                        dropSessionDidUpdate session: UIDropSession,
                        withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal
    {
        guard session.canLoadObjects(ofClass: Source.Item.self) else
        {
            return UICollectionViewDropProposal(operation: .cancel)
        }
        return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }

    // Loads the data provided by this drop.
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator)
    {
        coordinator.session.loadObjects(ofClass: Source.Item.self)
        { items /* [NSItemProviderReading] */ in

            guard let task = items.first as? Source.Item else {
                log.error("> Expected a Task object but got \(items.first as Any)")
                return
            }

            // The localContext contains the TaskList of the table where we initiated the drag.
            // We put it there ourselves in the TasklistDragDelegate.
            
            self.drop(item: task,
                      draggedCell: coordinator.session.localDragSession?.localContext as? DraggedCell,
                      sourceIndex: coordinator.items.first?.sourceIndexPath,
                      destinationIndex: coordinator.destinationIndexPath)
        }
    }

    private func drop(item: Source.Item,
                      draggedCell: DraggedCell<Source>?, /* may be nil when moving within a collection */
                      sourceIndex: IndexPath?,
                      destinationIndex: IndexPath?)
    {
        switch (sourceIndex, destinationIndex)
        {
            case let (.some(sourceIndexPath), .some(destinationIndexPath)):
                // item is moving within a table
                shiftItem(at: sourceIndexPath, to: destinationIndexPath)

            case (nil, let .some(destinationIndexPath)):
                // item came from a different table and was dropped over a cell
                draggedCell?.remove()
                move(item: item, at: destinationIndexPath)

            case (nil, nil):
                // item came from a different table and wasn’t dropped over a cell
                draggedCell?.remove()
                append(item: item)

            default:
                break
        }
    }
    
    // MARK: - Collection operations
    
    // The methods below perform the updates, then reload the index paths that changed.

    /// Change an item position within a table.
    private func shiftItem(at fromIndex: IndexPath, to toIndex: IndexPath)
    {
        let item = source.item(at: fromIndex.row)
        let updatedIndexPaths = updatedIndexesAfterShiftingItem(at: fromIndex, to: toIndex)
        collectionView.performBatchUpdates({
            source.remove(at: fromIndex.row)
            source.insert(item, at: toIndex.row)
            collectionView.reloadItems(at: updatedIndexPaths)
        })
    }
    
    // Return the rows whose position has changed when we move an item to a different position inside the table.
    //
    // 0123     0123
    // abcd --> acdb
    //  ^        ^^^ when b moves, cdb changed positions,
    // so updatedIndexPathMoving(from:1, to:3) returns indexes 123
    //
    private func updatedIndexesAfterShiftingItem(at: IndexPath, to: IndexPath) -> [IndexPath]
    {
        switch true
        {
            case at.row < to.row:
                return (at.row ... to.row).map { IndexPath(row: $0, section: 0) }

            case at.row > to.row:
                return (to.row ... at.row).map { IndexPath(row: $0, section: 0) }

            default:
                return []
        }
    }
    
    private func move(item: Source.Item, at destinationIndexPath: IndexPath)
    {
        collectionView.performBatchUpdates({
            source.insert(item, at: destinationIndexPath.row)
            collectionView.insertItems(at: [destinationIndexPath])
        })
    }
    
    private func append(item: Source.Item)
    {
        collectionView.performBatchUpdates({
            source.append(item)
            collectionView.insertItems(at: [IndexPath(row: self.source.count - 1, section: 0)])
        })
    }
}
