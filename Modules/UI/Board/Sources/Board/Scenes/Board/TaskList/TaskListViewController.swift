// swiftlint:disable weak_delegate

import MobileCoreServices
import os
import UIKit

/// Displays a list of tasks.
final class TaskListViewController: UIViewController, UICollectionViewDelegate
{
    typealias SomeCell = CardCell
    
    private let dragDelegate: UICollectionViewDragDelegate
    private let dropDelegate: UICollectionViewDropDelegate
    private var dataSource: CollectionDataSource<TaskList, SomeCell>
    private var taskListView: TaskListView
    private lazy var expandableCollectionDelegate = ExpandableCollectionDelegate(parent: self)
    var isStatusBarHidden = false
    
    private var collectionView: UICollectionView { taskListView.collectionView }

    init(_ source: TaskList,
         onDragDidEnd: @escaping () -> Void,
         onDragWillBegin: @escaping () -> Void)
    {
        let taskListView = TaskListView()
        let dataSource = TaskListCollectionDataSource<TaskList, SomeCell>(collectionView: taskListView.collectionView, source: source)
        self.dataSource = dataSource
        dragDelegate = CollectionDragDelegate<TaskList, SomeCell>(onDragDidEnd: onDragDidEnd,
                                                                  onDragWillBegin: onDragWillBegin,
                                                                  source: source)
        dropDelegate = CollectionDropDelegate(source: source, collectionView: taskListView.collectionView)
        self.taskListView = taskListView
        super.init(nibName: nil, bundle: nil)
        self.taskListView.title = source.title
        dataSource.addItemAction = { [weak self] in self?.addItem() }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView()
    {
        view = taskListView
        let collectionView = taskListView.collectionView
        collectionView.dataSource = dataSource
        collectionView.dragDelegate = dragDelegate
        collectionView.dropDelegate = dropDelegate
        collectionView.delegate = expandableCollectionDelegate
        collectionView.dragInteractionEnabled = true
    }
    
    override var prefersStatusBarHidden: Bool {
        isStatusBarHidden
    }

    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    // MARK: - Add an item
    
    func addItem()
    {
        let alert = Widgets.alert(title: i18n.addItem, ok: i18n.add, okAction: { alertController in
            if let title = alertController.textFields?.first?.text, !title.isEmpty
            {
                self.addItem(task: Task(title: title, tags: []))
            }
        })
        present(alert, animated: true, completion: nil)
    }
    
    private func addItem(task: TaskList.Item)
    {
        dataSource.appendItems([task])
        dataSource.indexPath(for: task).flatMap {
            collectionView.scrollToItem(at: $0, at: UICollectionView.ScrollPosition.top, animated: true)
        }
    }
}
