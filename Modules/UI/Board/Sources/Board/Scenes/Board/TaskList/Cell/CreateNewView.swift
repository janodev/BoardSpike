import UIKit

final class CreateNewView: UIView
{
    private let plusIcon = UIImageView()
    private let title = UILabel()
    private let button = UIButton()
    
    var addItemAction: (() -> Void) = {}
    
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
        addSubview(plusIcon)
        addSubview(title)
        addSubview(button)
        
        plusIcon.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        title.numberOfLines = 0
        title.textAlignment = .left
        title.font = Theme.Column.footer.font
        title.textColor = UIColor.link
        
        button.addTarget(self, action: #selector(didTap(sender:)), for: .touchUpInside)
        
        let views = ["button": button, "plusIcon": plusIcon, "title": title]
        [
            "H:|[button]",
            "H:|-[plusIcon]-[title]-(>=0)-|",
            "V:|-(2)-[plusIcon]",
            "V:|[button]|"
        ].forEach { constraints in
            NSLayoutConstraint.constraints(
                withVisualFormat: constraints,
                options: [],
                metrics: nil,
                views: views)
            .forEach { $0.isActive = true }
        }
        plusIcon.centerYAnchor.constraint(equalTo: title.centerYAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: title.trailingAnchor, constant: 30).isActive = true
        layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
        backgroundColor = .clear
    }
    
    func configure()
    {
        let icon = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(font: Theme.Column.footer.font))
        plusIcon.image = icon
        title.text = "Create"
    }
    
    @objc
    private func didTap(sender _: UIButton) {
        addItemAction()
    }
}
