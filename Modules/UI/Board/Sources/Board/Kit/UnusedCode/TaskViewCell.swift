
import os
import SwiftUI
import UIKit

final class TaskViewCell: UICollectionViewCell & Configurable
{
    static let reuseIdentifier = "TaskViewCell"
    
    //private lazy var controller = UIHostingController(rootView: TaskView(Task()))
    private lazy var controller = UIHostingController(rootView: TaskView(Task()))

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
        guard let innerView = controller.view else
        {
            log.error("> The hosting controller has no view.")
            return
        }
        contentView.addSubview(innerView)
        
        innerView.translatesAutoresizingMaskIntoConstraints = false

        innerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0.0).isActive = true
        innerView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
        innerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0.0).isActive = true

//        let bottom = innerView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
//        bottom.priority = UILayoutPriority.defaultHigh /* reusable cells offscreen are breaking constraints */
//        bottom.isActive = true
        
        // swiftlint:disable:next object_literal
        contentView.backgroundColor = UIColor(red: 236.0 / 255.0, green: 236.0 / 255.0, blue: 236.0 / 255.0, alpha: 1.0)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // A dequeued cell with a SwiftUI inner view may not resize to
        // the new data without invalidating the intrinsic content size.
        controller.view.invalidateIntrinsicContentSize()
    }
    
    func configure(_ model: Task)
    {
        controller.rootView = TaskView(model)
    }
}
