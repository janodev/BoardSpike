
import os
import UIKit

class CollectionDataSource
    <Source: DraggableSource, Cell: UICollectionViewCell & Configurable>
    : NSObject & UICollectionViewDataSource
    where Source.Item == Cell.Model
{
    private var source: Source
    private let collectionView: UICollectionView
    
    init(collectionView: UICollectionView, source: Source) {
        
        self.collectionView = collectionView
        self.source = source
        collectionView.register(Cell.self, forCellWithReuseIdentifier: Cell.reuseIdentifier)
    }
    
    // MARK: - Operations
    
    func deleteItems(_ models: [Cell.Model]) {
        collectionView.performBatchUpdates({
            let indexes = source.rows(for: models).map { IndexPath(row: $0, section: 0) }
            source.remove(models)
            collectionView.deleteItems(at: indexes)
        }, completion: nil)
    }
    
    func appendItems(_ models: [Cell.Model]) {
        collectionView.performBatchUpdates({
            source.append(models)
            let lastPosition = IndexPath(item: source.count - 1, section: 0)
            collectionView.insertItems(at: [lastPosition])
        })
    }
    
    func insertItems(_ identifier: Cell.Model, beforeItem toIdentifier: Cell.Model) {
        collectionView.performBatchUpdates({
            let index = source.row(for: toIdentifier)
            source.insert(identifier, at: index)
            collectionView.insertItems(at: [IndexPath(row: index, section: 0)])
        })
    }
    
    func moveItem(_ identifier: Cell.Model, to toIdentifier: Cell.Model) {
        collectionView.performBatchUpdates({
            let from = source.row(for: identifier)
            let to = source.row(for: toIdentifier)
            source.moveItem(identifier, beforeItem: toIdentifier)
            collectionView.moveItem(at: IndexPath(row: from, section: 0), to: IndexPath(row: to, section: 0))
        })
    }

    func reset(source: Source) {
        self.source = source
        collectionView.reloadData()
    }

    func item(for indexPath: IndexPath) -> Cell.Model? {
        source.item(at: indexPath.row)
    }
    
    func indexPath(for itemIdentifier: Cell.Model) -> IndexPath? {
        IndexPath(row: source.row(for: itemIdentifier), section: 0)
    }
    
    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        source.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as! Cell
        let item = source.items[indexPath.row]
        cell.configure(item)
        return cell
    }
    
    // footer
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView
    {
        switch kind {
            
        case CreateNewCell.kind:
            guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                ofKind: CreateNewCell.kind,
                withReuseIdentifier: CreateNewCell.reuseIdentifier,
                for: indexPath) as? CreateNewCell else { fatalError("Cannot create new supplementary with kind \(kind)") }
            return supplementaryView
            
        case BackgroundView.kind:
            guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                ofKind: BackgroundView.kind,
                withReuseIdentifier: BackgroundView.reuseIdentifier,
                for: indexPath) as? BackgroundView else { fatalError("Cannot create new supplementary with kind \(kind)") }
            return supplementaryView
        default:
            fatalError("Cannot create new supplementary with kind \(kind)")
        }
    }
}
