import AuthorizationApi
import Coordinator
import CredentialsStore
import os.log
import UIKit

final class BoardCoordinator: NavigationCoordinator
{
    var navigationController: UINavigationController?
    var children = [Coordinator]()
    var parent: Coordinator?
    var window: UIWindow
    var credentialsStore: CredentialsStore
    
    init(credentialsStore: CredentialsStore, parent: Coordinator, window: UIWindow)
    {
        self.credentialsStore = credentialsStore
        self.parent = parent
        self.window = window
        let navigationController = UINavigationController(nibName: nil, bundle: nil)
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.isHidden = false
        self.navigationController = navigationController
    }

    func start() {
        log.debug("Starting \(debugDescription)")
        let controller = BoardViewController(coordinator: self, credentialsStore: credentialsStore)
        navigationController?.pushViewController(controller, animated: false)
        window.rootViewController = navigationController
    }
    
    func finish()
    {
        log.debug("Removing myself \(self)")
        guard let parentVC = window.rootViewController else {
            parent?.remove(self)
            return
        }
        
        fadeToWhite(parentVC) {
            navigationController?.setViewControllers([], animated: false)
            parent?.remove(self)
        }
    }
    
    /// Fade the given controller to white.
    private func fadeToWhite(_ controller: UIViewController, completion: () -> Void)
    {
        let whiteVC = UIViewController()
        whiteVC.view.backgroundColor = .white
        whiteVC.view.alpha = 0
        whiteVC.view.frame = UIScreen.main.bounds
        controller.add(whiteVC)
        UIView.animate(
            withDuration: 1,
            animations: {
                whiteVC.view.alpha = 1
            }, completion: { _ in
                self.window.rootViewController = nil
                self.parent?.remove(self)
            }
        )
    }
}
