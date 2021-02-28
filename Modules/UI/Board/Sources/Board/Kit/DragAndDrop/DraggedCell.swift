import UIKit

/// Represents the dragged cell of a table view.
struct DraggedCell<Source: DraggableSource>  {

    /// Index path of the dragged cell
    private let draggedIndex: IndexPath
    
    /// Table containing that cell
    private let ownerCollection: UICollectionView
    
    /// Source data for that table
    private let source: Source
    
    init(draggedIndex: IndexPath, ownerCollection: UICollectionView, source: Source) {
        self.draggedIndex = draggedIndex
        self.ownerCollection = ownerCollection
        self.source = source
    }
    
    func remove() {
        ownerCollection.performBatchUpdates({
            source.remove(at: draggedIndex.row)
            ownerCollection.deleteItems(at: [draggedIndex])
        })
    }
}
