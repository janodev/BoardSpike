import Coordinator
import CredentialsStore
import os.log
import UIKit

public final class LoginCoordinator: RootCoordinator
{
    private var credentialsStore: CredentialsStore
    
    // MARK: - RootCoordinator
    
    public var children = [Coordinator]()
    public var parent: Coordinator?
    public var window: UIWindow

    public func start()
    {
        log.debug("Starting \(debugDescription)")
        let nativeLogin = NativeLogin(coordinator: self, credentialsStore: container.credentialsStore)
        let controller = NativeLoginViewController(nativeLogin: nativeLogin)
        window.rootViewController = controller
    }
    
    // MARK: - Initializer
    
    public init(credentialsStore: CredentialsStore,
                parent: Coordinator,
                window: UIWindow)
    {
        self.credentialsStore = credentialsStore
        self.parent = parent
        self.window = window
    }
    
    public convenience init?(window: UIWindow, parent: Coordinator) {
        self.init(credentialsStore: container.credentialsStore,
                  parent: parent,
                  window: window)
    }
}
