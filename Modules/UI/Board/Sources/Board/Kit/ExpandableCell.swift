import UIKit

final class ExpandableCellState
{
    var cornerRadius: CGFloat
    var frame: CGRect
    
    init(cornerRadius: CGFloat, frame: CGRect) {
        self.cornerRadius = cornerRadius
        self.frame = frame
    }
}

protocol ExpandableCell: UIView
{
    var initialState: ExpandableCellState? { get set }
    var contentView: UIView { get }
}

extension ExpandableCell
{
    /// Hides this cell to make room for the expansion of the selected cell.
    /// This is only called when this cell is not selected.
    ///
    /// Note that “expanding the selected cell” means changing its frame to fill
    /// the collection view, so its origin will equal `collectionView.contentOffset.y`.
    ///
    /// We pull all other cells upwards and downwards keeping their current distance
    /// to the selected cell. This produces an animation where the selected cell seems
    /// to be pushing other cells off.
    ///
    func hide(in collectionView: UICollectionView, frameOfSelectedCell: CGRect)
    {
        log.debug(">   hide \(Unmanaged.passUnretained(self as AnyObject).toOpaque())")
        initialState = ExpandableCellState(cornerRadius: contentView.layer.cornerRadius, frame: frame)
        let currentY = frame.origin.y
        let newY: CGFloat
        if currentY < frameOfSelectedCell.origin.y {
            // cells above are pushing upwards
            let offset = frameOfSelectedCell.origin.y - currentY // current distance to the cell
            newY = collectionView.contentOffset.y - offset       // push it over contentOffset.y to keep the distance
        } else {
            // cells below are pushing downwards
            let offset = currentY - frameOfSelectedCell.maxY
            newY = collectionView.contentOffset.y + collectionView.frame.height + offset
        }
        frame.origin.y = newY
        layoutIfNeeded()
    }
    
    /// Expand this selected cell to fill the collectionView.
    /// This is only called when this cell is the selected cell.
    func expand(in collectionView: UICollectionView)
    {
        log.debug("> expand \(Unmanaged.passUnretained(self as AnyObject).toOpaque())")
        initialState = ExpandableCellState(cornerRadius: contentView.layer.cornerRadius, frame: frame)
        let expandedState = createExpandedState(for: collectionView)
        apply(expandedState)
        layoutIfNeeded()
    }
    
    // Returns an state where this cell fills the whole collectionView.
    private func createExpandedState(for collectionView: UICollectionView) -> ExpandableCellState
    {
        let visibleRect = CGRect(
            x: 0,
            y: collectionView.contentOffset.y,
            width: collectionView.frame.width,
            height: collectionView.frame.height - 8
        )
        return ExpandableCellState(cornerRadius: 0, frame: visibleRect)
    }
    
    // Restore the collapsed cell frame.
    func restore()
    {
        log.debug("> restore \(Unmanaged.passUnretained(self as AnyObject).toOpaque())")
        apply(initialState)
        initialState = nil
        layoutIfNeeded()
    }
    
    // Apply the given state.
    private func apply(_ newState: ExpandableCellState?)
    {
        guard let state = newState else { return }
        contentView.layer.cornerRadius = state.cornerRadius
        frame = state.frame
    }
}
