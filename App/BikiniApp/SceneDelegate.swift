import AuthorizationApi
import Board
import Coordinator
import Networking
import os.log
import SwiftUI
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate
{
    var window: UIWindow?
    private var coordinator: Coordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions)
    {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            self.window = window
            coordinator = MainCoordinator(window: window, dependencies: container)
            coordinator?.start()
            window.makeKeyAndVisible()
        }
    }
}
