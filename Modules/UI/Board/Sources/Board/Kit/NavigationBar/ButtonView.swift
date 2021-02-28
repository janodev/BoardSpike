import UIKit

/// A view that contains a single button with an image and action.
final class ButtonView: UIView
{
    struct Icon
    {
        let image: UIImage
        // swiftlint:disable:next weak_delegate
        let dropInteractionDelegate: UIDropInteractionDelegate?
        let tintColor: UIColor?
        
        init(image: UIImage, dropInteractionDelegate: UIDropInteractionDelegate? = nil, tintColor: UIColor? = nil) {
            self.image = image
            self.dropInteractionDelegate = dropInteractionDelegate
            self.tintColor = tintColor
        }
    }
    
    struct Model
    {
        let action: (UIButton) -> Void
        let icon: Icon

        init(action: @escaping (UIButton) -> Void, icon: Icon) {
            self.action = action
            self.icon = icon
        }
    }
    
    private let action: (UIButton) -> Void
    private let button: UIButton
    // swiftlint:disable:next weak_delegate
    private let dropInteractionDelegate: UIDropInteractionDelegate?
    
    var isEnabled: Bool {
        get { button.isEnabled }
        set { button.isEnabled = newValue }
    }
    
    init(_ model: Model)
    {
        self.action = model.action
        self.button = UIButton(type: .custom)
        
        // the button holds a weak reference so we need to retain this or we lose it
        self.dropInteractionDelegate = model.icon.dropInteractionDelegate
        
        super.init(frame: CGRect.zero)
  
        configureButton(model.icon)
        layout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButton(_ icon: Icon) {
        button.setImage(icon.image, for: .normal)
        button.tintColor = icon.tintColor
        icon.dropInteractionDelegate.flatMap {
            button.addInteraction(UIDropInteraction(delegate: $0))
        }
        button.addTarget(self, action: #selector(runAction(sender:)), for: .touchUpInside)
    }
    
    private func layout()
    {
        addSubview(button)
        translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.topAnchor.constraint(equalTo: topAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc
    func runAction(sender: UIButton) {
        action(sender)
    }
}
