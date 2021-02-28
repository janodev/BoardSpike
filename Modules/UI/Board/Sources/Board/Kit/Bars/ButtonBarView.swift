import UIKit

/// A bar with a centered button.
final class ButtonBarView: UIView
{
    private let button = UIButton()
    private var action = {}

    private var _title: String = ""
    var title: String {
        get { _title }
        set {
            _title = newValue
            button.setAttributedTitle(Theme.Column.attributedTitle(title), for: .normal)
        }
    }
    
    /// - Parameters:
    ///   - title: Button title
    ///   - action: Button action
    init(title: String, action: @escaping () -> Void)
    {
        super.init(frame: CGRect.zero)
        setup()
        configure(title, action: action)
    }

    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
        setup()
    }

    private func setup()
    {
        addSubview(button)

        button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14).isActive = true
        button.topAnchor.constraint(equalTo: topAnchor, constant: 6).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false

        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.systemGray5
    }

    func configure(_ title: String, action: @escaping () -> Void)
    {
        self.action = action
        self.title = title
        button.addTarget(self, action: #selector(ButtonBarView.didTouchUpInside(sender:)), for: .touchUpInside)
    }

    @objc
    func didTouchUpInside(sender _: UIButton)
    {
        action()
    }
}
