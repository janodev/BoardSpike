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
    private let urlScheme: String

    public func start()
    {
        log.debug("Starting \(debugDescription)")
        let controller = LoginViewController(coordinator: self,
                                             credentialsStore: container.credentialsStore,
                                             urlScheme: urlScheme)
        window.rootViewController = controller
    }
    
    // MARK: - Initializer
    
    public init(credentialsStore: CredentialsStore,
                parent: Coordinator,
                urlScheme: String,
                window: UIWindow)
    {
        self.credentialsStore = credentialsStore
        self.parent = parent
        self.urlScheme = urlScheme
        self.window = window
    }
    
    public convenience init?(window: UIWindow, parent: Coordinator)
    {
        guard let urlScheme = InfoPlist().bundleURLSchemes().first else {
            log.error("Couldn’t figure out the URL scheme. Did you register any?")
            return nil
        }
        self.init(credentialsStore: container.credentialsStore,
                  parent: parent,
                  urlScheme: urlScheme,
                  window: window)
    }
}
