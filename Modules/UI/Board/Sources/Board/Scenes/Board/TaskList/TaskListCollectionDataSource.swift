
import os
import UIKit

class TaskListCollectionDataSource
    <Source: DraggableSource, Cell: UICollectionViewCell & Configurable>
    : CollectionDataSource<Source, Cell>
    where Source.Item == Cell.Model
{
    var addItemAction: () -> Void = {}
    
    override func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath) -> UICollectionReusableView
    {
        switch kind {
            
        case CreateNewCell.kind:
            guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                ofKind: CreateNewCell.kind,
                withReuseIdentifier: CreateNewCell.reuseIdentifier,
                for: indexPath) as? CreateNewCell else { fatalError("Cannot create new supplementary with kind \(kind)") }
            supplementaryView.addItemAction = addItemAction
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
