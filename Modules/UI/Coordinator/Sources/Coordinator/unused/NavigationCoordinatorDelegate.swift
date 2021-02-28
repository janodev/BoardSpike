
import UIKit

/* unused - try it to attach a module when a navigation controller already exist */
final class NavigationCoordinatorDelegate<InitialController> {
    
    private weak var coordinator: Coordinator?
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // read the view controller we’re moving from.
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }

        // check whether our view controller array already contains that view controller.
        if navigationController.viewControllers.contains(fromViewController) {
            // we’re pushing a different view controller on top rather than popping it, so exit.
            return
        }

        // we’re popping the view controller, check whether it’s the initial one
        // or should we check for the number of stacked controllers?
        if fromViewController is InitialController {
            // end its coordinator
            coordinator?.finish()
            // childDidFinish(buyViewController.coordinator)
        }
    }
}
