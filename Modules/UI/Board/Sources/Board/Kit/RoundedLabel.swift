
import UIKit

final class RoundedLabel: UILabel
{
    override var intrinsicContentSize: CGSize
    {
        let defaultSize = super.intrinsicContentSize
        return CGSize(width: defaultSize.width + 8, height: defaultSize.height + 2)
    }
    
    init() {
        super.init(frame: CGRect.zero)
        layer.cornerRadius = 4
        layer.masksToBounds = true
        textAlignment = .center
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
