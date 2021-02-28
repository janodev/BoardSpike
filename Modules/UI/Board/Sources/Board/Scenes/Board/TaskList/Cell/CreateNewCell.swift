import UIKit

final class CreateNewCell: UICollectionReusableView, ExpandableCell
{
    static let reuseIdentifier = "CreateNewCell"
    static let kind = "CreateNewCell"

    private let createNewView = CreateNewView()
    
    var initialState: ExpandableCellState?
    var contentView: UIView { self }
    
    var addItemAction: (() -> Void) {
        get { createNewView.addItemAction }
        set { createNewView.addItemAction = newValue }
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        initViews()
    }

    @available(*, unavailable)
    required init(coder _: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initViews()
    {
        addSubview(createNewView)
        Layout.pinToSuperview(createNewView)
        layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        backgroundColor = UIColor.systemGray5
        roundCorners(corners: [.bottomLeft, .bottomRight], radius: 12.0)
        createNewView.configure()
    }
}
