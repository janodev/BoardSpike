
import os
import UIKit

final class BoardView: UIView
{
    private let TOP_BAR_HEIGHT: CGFloat = 44
    private let MIN_CELL_WIDTH: CGFloat = 230
    private let SPACING: CGFloat = 10
    private lazy var MAX_CELL_WIDTH = UIScreen.main.bounds.width - 2 * SPACING

    private var cellWidth: CGFloat = 230 {
        didSet {
            postGeometryChange()
            collectionView.collectionViewLayout = boardLayout()
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    private let stackView = UIStackView()
    private lazy var pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(pinch:)))
    lazy var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: boardLayout())

    // MARK: - Initialization
    
    init(title: String)
    {
        super.init(frame: CGRect.zero)
        addGestureRecognizer(pinchGesture)
        layout()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    private func layout()
    {
        addSubview(stackView)
        stackView.addArrangedSubview(collectionView)
        Layout.pinToSuperviewSafeArea(stackView)
        stackView.insetsLayoutMarginsFromSafeArea = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        backgroundColor = Theme.background
    }
    
    // MARK: - Pinching

    @objc
    private func handlePinch(pinch: UIPinchGestureRecognizer)
    {
        cellWidth = width(for: pinch.scale)
    }
    
    // Return a new cell width for the given pinch gesture scale.
    private func width(for scale: CGFloat) -> CGFloat {
        var scale = scale
        scale = Swift.max(scale, 0.2)
        scale = Swift.min(scale, 1.2)
        let perOne = scale - 0.2
        return MIN_CELL_WIDTH + (MAX_CELL_WIDTH - MIN_CELL_WIDTH) * perOne
    }
    
    private func postGeometryChange() {
        NotificationCenter.default.post(name: Notification.Name.ColumnWidthChange, object: nil)
    }
    
    // MARK: - Layout
    
    private func boardLayout() -> UICollectionViewLayout
    {
        let inset = CGFloat(SPACING) // space around columns, but not between groups
        let groupSpace = CGFloat(SPACING) // space between groups
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(cellWidth), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = groupSpace
        section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        section.orthogonalScrollingBehavior = .groupPaging

        return UICollectionViewCompositionalLayout(section: section)
    }
}
