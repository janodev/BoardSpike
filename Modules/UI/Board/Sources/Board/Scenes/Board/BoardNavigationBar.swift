import os.log
import UIKit

// A factory to create BoardNavigationBar instances.
private final class BoardNavigationBarFactory
{
    private weak var controller: BoardViewController?
    
    init(controller: BoardViewController) {
        self.controller = controller
    }
    
    func build() -> BoardNavigationBar? {
        
        guard let controller = controller else { return nil }
        
        return BoardNavigationBar(
            controller: controller,
            leftMenu: [
                
                Menu.popupButton(
                    icon("ellipsis"),
                    [MenuItem(id: .logout, action: { [weak controller] (_ origin: UIView) in controller?.logout() })]
                ),
                
                Menu.button(
                    ButtonView.Model(
                        action: { _ in /* empty */ },
                        icon: ButtonView.Icon(
                            image: image("trash"),
                            dropInteractionDelegate: RemoveRowDropDelegate<TaskList>(),
                            tintColor: .red
                        )
                    )
                )
            ],
            rightMenu: [
                
                Menu.button(
                    ButtonView.Model(
                        action: { [weak controller] _ in controller?.offerToCreateTaskList() },
                        icon: icon("plus")
                    )
                )
            ]
        )
    }
    
    private func image(_ systemName: String) -> UIImage {
        UIImage(systemName: systemName) ?? UIImage()
    }
    private func icon(_ systemName: String) -> ButtonView.Icon {
        ButtonView.Icon(image: image(systemName))
    }
}

/*
 Navigation bar for the BoardViewController.
 
 See NavigationBar for usage.
 See BoardNavigationBarFactory for the data model that defines the bar items.
*/
final class BoardNavigationBar: NavigationBar
{
    var isDragging: Bool = false {
        didSet {
            trashButtonView?.isHidden = !isDragging
            ellipsisButtonView?.isEnabled = !isDragging
            plusButtonView?.isEnabled = !isDragging
        }
    }
    
    static func createInstance(parentController: BoardViewController) -> BoardNavigationBar? {
        BoardNavigationBarFactory(controller: parentController).build()
    }
    
    override func attachBarButtonItems() {
        super.attachBarButtonItems()
        isDragging = false
    }
    
    // MARK: - Access to specific UIBarButtonItems
    
    private var ellipsisButtonView: ButtonView? {
        leftItem(at: 0)?.customView as? ButtonView
    }
    
    private var trashButtonView: ButtonView? {
        leftItem(at: 1)?.customView as? ButtonView
    }
    
    private var plusButtonView: ButtonView? {
        rightItem(at: 0)?.customView as? ButtonView
    }
    
    private func leftItem(at index: Int) -> UIBarButtonItem? {
        guard let count = controller?.navigationItem.leftBarButtonItems?.count, count > index else {
            log.error("No left BarButtonItem at index \(index)")
            return nil
        }
        return controller?.navigationItem.leftBarButtonItems?[index]
    }
    
    private func rightItem(at index: Int) -> UIBarButtonItem? {
        guard let count = controller?.navigationItem.rightBarButtonItems?.count, count > index else {
            log.error("No right BarButtonItem at index \(index)")
            return nil
        }
        return controller?.navigationItem.rightBarButtonItems?[index]
    }
}
