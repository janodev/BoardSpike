
import os
import UIKit

final class ExpandableCollectionDelegate: NSObject, UICollectionViewDelegate {
    
    typealias Expandable = UIView & ExpandableCell
    
    private var hiddenCells: [Expandable] = []
    private var expandedCell: Expandable?
    private weak var parent: TaskListViewController?

    // This view stands between the first cell and the top of the collectionView.
    // Usually when we pull down we would see the background of the collection,
    // but thanks to stretchSpacer(_:) we see instead this view.
    private var spacer: VoidFillerView?
    
    init(parent: TaskListViewController) {
        self.parent = parent
        super.init()
        listenForGeometryChanges()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        stretchSpacer(scrollView)
    }
    
    // --
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if let selectedCell = expandedCell {
            collapse(collectionView, selectedCell: selectedCell)
        } else {
            (collectionView.cellForItem(at: indexPath) as? Expandable).flatMap {
                expand(collectionView, selectedCell: $0)
            }
        }
    }
    
    private func collapse(_ collectionView: UICollectionView, selectedCell: Expandable)
    {
        guard let parent = self.parent else { return }
        parent.isStatusBarHidden = false
        parent.view.isUserInteractionEnabled = false
        
        let animator = createAnimator()
        animator.addAnimations { [parent] in
            selectedCell.restore()
            self.hiddenCells.forEach { $0.restore() }
            parent.setNeedsStatusBarAppearanceUpdate()
        }
        animator.addCompletion { [parent] _ in
            collectionView.isScrollEnabled = true
            self.expandedCell = nil
            self.hiddenCells.removeAll()
            parent.view.isUserInteractionEnabled = true
        }
        animator.startAnimation()
    }
    
    private func expand(_ collectionView: UICollectionView, selectedCell: Expandable)
    {
        guard let parent = self.parent else { return }
        parent.isStatusBarHidden = true
        parent.view.isUserInteractionEnabled = false
        collectionView.isScrollEnabled = false
        
        let animator = createAnimator()
        expandedCell = selectedCell
        hiddenCells = collectionView.visibleCells.compactMap {
            if $0 == selectedCell { return nil }
            guard let cell = $0 as? Expandable else {
                fatalError("Expected a subclass of UIView & ExpandableCell.")
            }
            return cell
        }

        if let footer = collectionView
            .visibleSupplementaryViews(ofKind: CreateNewCell.kind)
            .first as? ExpandableCell {
            hiddenCells.append(footer)
        }
        
        animator.addAnimations {
            let frameOfSelectedCell = selectedCell.frame
            selectedCell.expand(in: collectionView)
            self.hiddenCells.forEach { $0.hide(in: collectionView, frameOfSelectedCell: frameOfSelectedCell) }
            parent.setNeedsStatusBarAppearanceUpdate()
        }
        animator.addCompletion { [parent] _ in
            parent.view.isUserInteractionEnabled = true
        }
        animator.startAnimation()
    }
    
    // Return the animator for the cell collapse and expansion.
    private func createAnimator() -> UIViewPropertyAnimator
    {
        let dampingRatio: CGFloat = 0.8
        let initialVelocity = CGVector.zero
        let springParameters = UISpringTimingParameters(dampingRatio: dampingRatio, initialVelocity: initialVelocity)
        return UIViewPropertyAnimator(duration: 0.5, timingParameters: springParameters)
    }
    
    // MARK: - listen for changes
    
    // If there is a geometry change the cells are restored to their new size.
    // Here we drop the hidden and expanded cells so the cells remain as if expansion never happened.
    private func listenForGeometryChanges() {
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeGeometry), name: UIDevice.orientationDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeGeometry), name: NSNotification.Name.ColumnWidthChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeGeometry), name: NSNotification.Name.DragSessionWillBegin, object: nil)
    }
    
    @objc
    private func didChangeGeometry() {
        self.hiddenCells = []
        self.expandedCell = nil
        parent?.view.isUserInteractionEnabled = true
    }
    
    // Stretches the spacer view to fill the void caused when we scroll down beyond the limits.
    private func stretchSpacer(_ scrollView: UIScrollView) {
        
        guard scrollView.contentOffset.y < 0 else {
            return // regular scrolling
        }
        
        // At this point we are pulling down to leave a void between the top and the first cell.
        
        if spacer == nil {
            self.spacer = scrollView.subviews.first { view in view is VoidFillerView } as? VoidFillerView
        }
        guard let spacer = self.spacer else {
            log.error("Expected to find a spacer view subview of the collection view.")
            return
        }
        
        var newFrame = scrollView.frame
        newFrame.origin.y = scrollView.contentOffset.y
        newFrame.size.height = Swift.abs(scrollView.contentOffset.y)
        spacer.frame = newFrame
    }
}
