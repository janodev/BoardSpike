import Foundation
import os
import UIKit

/// UICollectionView dragging delegate.
final class CollectionDragDelegate
    <Source: DraggableSource, Cell: UICollectionViewCell & Configurable>
    : NSObject & UICollectionViewDragDelegate
    where Source.Item == Cell.Model
{
    private let source: Source
    private let onDragWillBegin: () -> Void
    private let onDragDidEnd: () -> Void
    
    init(onDragDidEnd: @escaping () -> Void,
         onDragWillBegin: @escaping () -> Void,
         source: Source)
    {
        self.source = source
        self.onDragDidEnd = onDragDidEnd
        self.onDragWillBegin = onDragWillBegin
    }
    
    /// Returns a drag item containing the task of the dragged row.
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem]
    {
        log.debug("Dragging index \(indexPath) of table with \(collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: 0) ?? 0) rows")
        session.localContext = DraggedCell(draggedIndex: indexPath, ownerCollection: collectionView, source: source)

        let item = source.item(at: indexPath.row)
            |> NSItemProvider.init(object:)
            |> UIDragItem.init(itemProvider:)
        
        return [item]
    }

    /// Action to execute when the drag session begins.
    func collectionView(_ collectionView: UICollectionView, dragSessionWillBegin session: UIDragSession)
    {
        NotificationCenter.default.post(name: Notification.Name.DragSessionWillBegin, object: nil)
        onDragWillBegin()
    }

    /// Action to execute when the drag session ends.
    func collectionView(_ collectionView: UICollectionView, dragSessionDidEnd session: UIDragSession)
    {
        onDragDidEnd()
    }
}
