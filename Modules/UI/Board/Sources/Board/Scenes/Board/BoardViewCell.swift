import MobileCoreServices
import UIKit

final class BoardViewCell: UICollectionViewCell
{
    static let reuseIdentifier = "BoardView"
    
    private var listController: TaskListViewController?

    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
        setup()
    }

    private func setup()
    {
        layer.masksToBounds = true
        layer.cornerRadius = 10.0
    }

    private func resetController(_ model: BoardViewCellModel)
    {
        contentView.subviews.forEach { $0.removeFromSuperview() }

        let listController = TaskListViewController(
            model.taskList,
            onDragDidEnd: model.onDragDidEnd,
            onDragWillBegin: model.onDragWillBegin
        )
        contentView.addSubview(listController.view)

        listController.view.translatesAutoresizingMaskIntoConstraints = false
        listController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        listController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        listController.view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        listController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true

        self.listController = listController
    }
}

extension BoardViewCell: Configurable
{
    func configure(_ model: BoardViewCellModel)
    {
        resetController(model)
    }
}
