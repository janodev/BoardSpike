import UIKit

final class CardCell: UICollectionViewCell, ExpandableCell, Configurable
{
    static let reuseIdentifier = "CardCell"

    let cardView = CardView()
    var initialState: ExpandableCellState?
    
    override var contentView: UIView { super.contentView }
    
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
        addSubview(cardView)
        layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
        Layout.pinToSuperviewLayoutMarginsGuide(cardView)
        
        backgroundColor = UIColor.systemGray5
        clipsToBounds = true
        layer.cornerRadius = 12.0
    }
    
    func configure(_ model: Task)
    {
        cardView.configure(model)
    }
}
