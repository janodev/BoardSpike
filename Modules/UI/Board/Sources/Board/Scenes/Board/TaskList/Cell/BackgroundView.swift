import UIKit

final class BackgroundView: UICollectionReusableView
{
    static let reuseIdentifier = "BackgroundView"
    static let kind = "BackgroundView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    // swiftlint:disable:next unavailable_function
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
}

extension BackgroundView
{
    func configure()
    {
        backgroundColor = UIColor.systemGray5
        layer.cornerRadius = 12
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
}
