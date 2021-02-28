// swiftlint:disable implicitly_unwrapped_optional
import AuthorizationApi
import Coordinator
import CredentialsStore
import MobileCoreServices
import os
import UIKit

public final class BoardViewController: UIViewController
{
    private weak var coordinator: NavigationCoordinator?
    private var boardView: BoardView
    private var board: Board!
    private var credentialsStore: CredentialsStore
    private var collectionView: UICollectionView { boardView.collectionView }
    private var dataSource: CollectionDataSource<Board, BoardViewCell>!
    private var boardNavigationBar: BoardNavigationBar?
    private let boardTitle = "Sprint 13"

    public init(coordinator: NavigationCoordinator, credentialsStore: CredentialsStore)
    {
        self.coordinator = coordinator
        self.credentialsStore = credentialsStore
        boardView = BoardView(title: boardTitle)
        super.init(nibName: nil, bundle: nil)

        configureNavigationBar()
        configureCollectionView()
    }
    
    private func configureNavigationBar()
    {
        let titleLabel = UILabel()
        titleLabel.attributedText = Theme.attributedTitle(boardTitle)
        navigationItem.titleView = titleLabel
        boardNavigationBar = BoardNavigationBar.createInstance(parentController: self)
        boardNavigationBar?.attachBarButtonItems()
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
    
    private func configureCollectionView()
    {
        let taskListArray = boardData
        self.board = Board(boards: taskListArray.map { self.cellModel(taskList: $0) })
        dataSource = CollectionDataSource<Board, BoardViewCell>(collectionView: boardView.collectionView, source: board)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.backgroundColor = Theme.background
    }

    // MARK: - UIView

    @available(*, unavailable)
    required init(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func loadView() {
        view = boardView
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - TaskList creation
    
    // Show an alert with input for an item title.
    func offerToCreateTaskList()
    {
        let alert = Widgets.alert(title: "Add List", ok: "Add", okAction: { controller in
            if let title = controller.textFields?.first?.text, !title.isEmpty {
                let randomId = Int.random(in: 0...Int.max - 1)
                self.addTaskList(TaskList(id: randomId, title: title))
            }
        })
        present(alert, animated: true)
    }
    
    func logout() {
        credentialsStore.credentials = nil
        coordinator?.finish()
    }
    
    // Adds a list.
    private func addTaskList(_ itemList: TaskList)
    {
        let cellModel = BoardViewCellModel(
            onDragDidEnd: { [weak self] in self?.boardNavigationBar?.isDragging = false },
            onDragWillBegin: { [weak self] in self?.boardNavigationBar?.isDragging = true },
            taskList: itemList
        )
        dataSource.appendItems([cellModel])
        
        if let lastIndex = dataSource.indexPath(for: cellModel) {
            collectionView.scrollToItem(at: lastIndex, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        }
    }
    
    // MARK: - Other
    
    private func cellModel(taskList: TaskList) -> BoardViewCellModel {
        BoardViewCellModel(
            onDragDidEnd: { [weak self] in self?.boardNavigationBar?.isDragging = false },
            onDragWillBegin: { [weak self] in self?.boardNavigationBar?.isDragging = true },
            taskList: taskList
        )
    }
}

extension BoardViewController: UICollectionViewDelegate
{
    public func collectionView(_: UICollectionView, didSelectItemAt _: IndexPath)
    {
        log.debug("Clicked on a collection cell of BoardViewController. No action defined.")
    }
}
