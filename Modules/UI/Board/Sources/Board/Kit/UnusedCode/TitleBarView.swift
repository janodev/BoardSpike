import UIKit

final class TitleBarView: UIView
{
    private let title = UILabel()

    init()
    {
        super.init(frame: CGRect.zero)
        setup()
    }

    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
        setup()
    }

    private func setup()
    {
        addSubview(title)
        Layout.center(title)
        translatesAutoresizingMaskIntoConstraints = false
    }

    func setTitle(_ string: String)
    {
        title.text = string
    }
}
