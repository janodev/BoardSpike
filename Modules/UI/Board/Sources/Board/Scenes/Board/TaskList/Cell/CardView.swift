import UIKit

final class CardView: UIView {
    
    // swiftlint:disable:next force_unwrapping
    private let avatar = UIImageView(image: UIImage(named: "sofia", in: Bundle.main, with: nil)!)
    private let code = UILabel()
    private let icon = UIImageView(image: UIImage(systemName: "cloud.heavyrain.fill"))
    private let tagStack = UIStackView()
    private let title = UILabel()
    
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
        addSubview(avatar)
        addSubview(code)
        addSubview(icon)
        addSubview(tagStack)
        addSubview(title)
        
        avatar.translatesAutoresizingMaskIntoConstraints = false
        code.translatesAutoresizingMaskIntoConstraints = false
        icon.translatesAutoresizingMaskIntoConstraints = false
        tagStack.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        
        title.numberOfLines = 0
        tagStack.spacing = 10
        avatar.layer.cornerRadius = 10.0
        avatar.clipsToBounds = true
        layer.cornerRadius = 12.0
        
        let views = ["avatar": avatar, "code": code, "icon": icon, "tagStack": tagStack, "title": title]
        var constraints = [NSLayoutConstraint]()
        constraints.append(contentsOf: NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[title]-|", options: [], metrics: nil, views: views))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[tagStack]-(>=0)-|", options: [], metrics: nil, views: views))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[icon(20)]-[code]-(>=12)-[avatar(20)]-|", options: [], metrics: nil, views: views))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[title]-[tagStack]-[icon(20)]-|", options: [], metrics: nil, views: views))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(
            withVisualFormat: "V:[avatar(20)]-|", options: [], metrics: nil, views: views))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(
            withVisualFormat: "V:[code(20)]-|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activate(constraints)
        
        backgroundColor = .white
        icon.tintColor = Theme.Task.iconTint
    }
    
    func configure(_ model: Task)
    {
        title.attributedText = Theme.Task.attributedTitle(model.title)
        code.attributedText = Theme.Task.attributedCode("TRS-18")
        tagStack.arrangedSubviews.forEach {
            tagStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        model.tags.forEach { tagStack.addArrangedSubview(tag($0)) }
    }
    
    private func tag(_ text: String) -> UILabel
    {
        let label = RoundedLabel()
        label.attributedText = Theme.Task.attributedTag(text)
        label.layer.backgroundColor = Theme.Task.tagBackground.cgColor
        return label
    }
}
