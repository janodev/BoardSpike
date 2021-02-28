
import UIKit

/// Identifiers for menu entries.
enum MenuItemId: Equatable, CustomStringConvertible
{
    case logout

    var description: String {
        switch self {
        case .logout: return "Logout"
        }
    }
}

/// Menu
struct MenuItem {
    /// Identifier and title of the menu entry
    let id: MenuItemId
    let action: (_ sender: UIView) -> Void
}

/// A menu is made of buttons and popup buttons containing menu items.
enum Menu {
    case button(ButtonView.Model)
    case popupButton(ButtonView.Icon, [MenuItem])
}

/*
 Creates stacks of UIBarButtonItems for the navigation bar of the given controller.

 Usage:
 ```
 let leftMenu = ...the model for the stack of buttons on the left side
 NavigationBar(controller, leftMenu, rightMenu).attachBarButtonItems()
 ```
*/
class NavigationBar
{
    weak var controller: UIViewController?
    private let leftMenu: [Menu]
    private let rightMenu: [Menu]
    
    init(controller: UIViewController, leftMenu: [Menu], rightMenu: [Menu])
    {
        self.controller = controller
        self.leftMenu = leftMenu
        self.rightMenu = rightMenu
    }
    
    /// Set the UIBarButtonItem
    func attachBarButtonItems() {
        controller?.navigationItem.leftBarButtonItems = leftMenu.map { type(of: self).createView($0, controller) }
        controller?.navigationItem.rightBarButtonItems = rightMenu.map { type(of: self).createView($0, controller) }
    }
    
    private static func createView(_ menu: Menu, _ presentingController: UIViewController?) -> UIBarButtonItem
    {
        switch menu {
        case let .button(buttonModel):
            return UIBarButtonItem(customView: ButtonView(buttonModel))
        case let .popupButton(icon, menuItems):
            let action: (UIView) -> Void = { [weak presentingController] button in
                NavigationBar.showMenu(items: menuItems, origin: button, presentedBy: presentingController)
            }
            let model = ButtonView.Model(action: action, icon: icon)
            return UIBarButtonItem(customView: ButtonView(model))
        }
    }
    
    private static func showMenu(items: [MenuItem], origin: UIView, presentedBy controller: UIViewController?)
    {
        let menuController = TableViewController<MenuItemId>(rows: items.map { $0.id })
        
        let widthThatLooksGood = 200
        let standardCellHeight = 44
        menuController.preferredContentSize = CGSize(width: widthThatLooksGood, height: standardCellHeight * items.count)
        /* An alternative cheap way to calculate the size is to call reloadData(), layoutIfNeeded() in viewDidLoad(),
           and then read menuController.tableView.contentSize.height. Unfortunately, this shows a harmless warning
           that the table is being drawn outside a hierarchy.
         */
        
        let popup = PopupMenuController(
            menuController: menuController,
            focusedView: origin,
            presentingController: controller
        )
        
        menuController.onTapRow = { [weak popup] in
            NavigationBar.onTapCommand(items: items, id: $0)
            popup?.removeMenuController()
            popup?.removeThisController()
        }
        popup.showMenu()
    }
    
    private static func onTapCommand(items: [MenuItem], id: MenuItemId)
    {
        let tappedItem = items.first { item in item.id == id }
        let originCell = UIView() // implementing this is not needed
        tappedItem?.action(originCell)
    }
}
