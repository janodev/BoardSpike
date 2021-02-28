import UIKit

public protocol NavigationCoordinator: Coordinator {
    var navigationController: UINavigationController? { get }
}
