import UIKit

final class VoidFillerView: UIView {}

/// A table with a button on top.
final class TaskListView: UIStackView
{
    @IBAction private func didTapAdd()
    {
        addItemAction()
    }
    
    private let TOP_BAR_HEIGHT = CGFloat(35)
    private let FOOTER_HEIGHT = CGFloat(27)

    lazy var collectionView: UICollectionView =
    {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: columnLayout())
        collectionView.backgroundColor = Theme.background
        collectionView.register(
            CreateNewCell.self,
            forSupplementaryViewOfKind: CreateNewCell.kind,
            withReuseIdentifier: CreateNewCell.reuseIdentifier
        )
        let spacer = VoidFillerView(frame: CGRect.zero)
        spacer.backgroundColor = UIColor.systemGray5
        collectionView.insertSubview(spacer, at: 0)
        return collectionView
    }()
    
    private lazy var buttonBarView: ButtonBarView =
    {
        let buttonBarView = ButtonBarView(title: "ADD") { [weak self] in self?.addItemAction() }
        Layout.view(buttonBarView, setHeight: TOP_BAR_HEIGHT, priority: .defaultHigh)
        return buttonBarView
    }()

    var addItemAction: () -> Void = {}

    private var _title: String = ""
    var title: String {
        get { _title }
        set {
            _title = newValue
            buttonBarView.title = title
        }
    }
    
    required init()
    {
        super.init(frame: CGRect.zero)
        setup()
    }

    @available(*, unavailable)
    required init(coder _: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup()
    {
        overrideUserInterfaceStyle = .light
        axis = .vertical
        addArrangedSubview(buttonBarView)
        addArrangedSubview(collectionView)
    }
    
    private func columnLayout() -> UICollectionViewLayout
    {
        // 100% of the group width and height
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // width = 100% width, height = 150 points
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let background = NSCollectionLayoutDecorationItem.background(elementKind: BackgroundView.kind)
        background.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(FOOTER_HEIGHT)),
            elementKind: CreateNewCell.kind,
            alignment: .bottom)
        sectionFooter.extendsBoundary = true
        sectionFooter.pinToVisibleBounds = false

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
        section.decorationItems = [background]
        section.boundarySupplementaryItems = [sectionFooter]
        section.supplementariesFollowContentInsets = true
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.register(BackgroundView.self, forDecorationViewOfKind: BackgroundView.kind)

        return layout
    }
}
