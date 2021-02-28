import UIKit

final class SectionBackgroundDecorationView: UICollectionReusableView {

    static let kind = "SectionBackgroundDecorationView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }

    func configure() {
        backgroundColor = UIColor.red.withAlphaComponent(1.0)
        layer.borderColor = UIColor.yellow.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 12
    }
}
