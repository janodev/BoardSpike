import UIKit

enum Layout
{
    static func center(_ view: UIView)
    {
        guard let superView = view.superview else { return }
        view.centerXAnchor.constraint(equalTo: superView.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: superView.centerYAnchor).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
    }

    static func view(_ view: UIView, setHeight height: CGFloat, priority: UILayoutPriority = .required)
    {
        view.translatesAutoresizingMaskIntoConstraints = false
        let height = view.heightAnchor.constraint(equalToConstant: height)
        height.priority = priority
        height.isActive = true
    }

    static func pinToSuperview(_ view: UIView)
    {
        guard let superview = view.superview else { return }
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
    }
    
    static func pinToSuperviewLayoutMarginsGuide(_ view: UIView)
    {
        guard let superview = view.superview else { return }
        let guide = superview.layoutMarginsGuide
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
    }
    
    static func pinToSuperviewSafeArea(_ view: UIView)
    {
        guard let superview = view.superview else { return }
        let guide = superview.safeAreaLayoutGuide
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
    }
}
