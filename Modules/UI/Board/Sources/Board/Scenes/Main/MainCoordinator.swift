import AuthorizationApi
import Coordinator
import CredentialsStore
import NativeLogin
import os.log
import UIKit
import WebLogin

public final class MainCoordinator: RootCoordinator
{
    private let useNativeLogin = false
    
    // MARK: - RootCoordinator
    
    public var children = [Coordinator]() {
        didSet {
            if children.isEmpty {
                log.debug("No children left. Calling start() again")
                start()
            }
        }
    }
    public var parent: Coordinator?
    public var window: UIWindow

    public func start()
    {
        log.debug("Starting \(debugDescription)")
        guard let child = initial() else {
            log.error("Can’t start. The initial coordinator is not ready.")
            return
        }
        children = [child]
        child.start()
    }
    
    public func finish() { /* never ends */ }
    
    private func initial() -> Coordinator? {
        switch credentialsStore.credentials {
        case .some:
            return BoardCoordinator(credentialsStore: credentialsStore, parent: self, window: window)
        case .none:
            log.debug("Missing credentials. Navigating to login.")
            return useNativeLogin
                ? NativeLogin.LoginCoordinator(window: window, parent: self)
                : WebLogin.LoginCoordinator(window: window, parent: self)
        }
    }
    
    // MARK: - Initializer
    
    public typealias Dependencies = HasCredentialsStore
    private var credentialsStore: CredentialsStore

    public init(window: UIWindow, dependencies: Dependencies) {
        self.credentialsStore = dependencies.credentialsStore
        self.window = window
    }
}
