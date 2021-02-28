import UIKit

/*
 Displays the given UIViewController as a popup.
 
 Usage:
 ```
 let controller: UIViewController = ...the controller inside the popup
 PopupMenuController(controller, originView, parentController).showMenu()
 ```
 
 If you want to know how to display a popup with a dimmed background,
 here is how it’s done in this controller:
 
     1. It nest this controller on the parent and sets the same frame so it covers the parent completely.
     2. It dims the background of the controller.
        At this point the underlying controller is dimmed.
     3. It snapshots the originView and adds it to this controller.
        This creates the illusion of dimming everything except the source view.
     4. It presents the controller of the menu as a popup.
     5. It sets a delegate that dismisses this controller when the popup is dismissed.
*/
final class PopupMenuController: UIViewController
{
    private let menuController: UIViewController
    private let focusedView: UIView
    private weak var presentingController: UIViewController?
    private let dimmingDuration: TimeInterval = 0.2

    /// - Parameters:
    ///   - menuController: controller presented in the popup
    ///   - focusedView: source of the popup menu
    ///   - presentingController: controller presenting the popup
    init(menuController: UIViewController,
         focusedView: UIView,
         presentingController: UIViewController?)
    {
        self.menuController = menuController
        self.focusedView = focusedView
        self.presentingController = presentingController
        super.init(nibName: nil, bundle: nil)
    }
    
    // swiftlint:disable:next unavailable_function
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // Snapshot the focused view and place the snapshot over the original.
    func showMenu()
    {
        nestController(on: presentingController)
        guard let snapshot = placeSnapshot(focusedView: focusedView) else { return }
        presentMenuFromSourceView(snapshot)
        dimBackground()
    }
    
    private func nestController(on parent: UIViewController?)
    {
        guard let parent = parent else { return }
        parent.add(self)
        
        var overlappingFrame = parent.view.frame
        overlappingFrame.origin = CGPoint.zero
        view.frame = overlappingFrame
    }
     
    private func placeSnapshot(focusedView: UIView) -> UIView?
    {
        guard let snapshotView = focusedView.snapshotView(afterScreenUpdates: false) else {
            return nil
        }
        view.addSubview(snapshotView)
        guard let focusedViewSuperview = focusedView.superview else {
            return nil
        }
        let convertedFrame = view.convert(focusedView.frame, from: focusedViewSuperview)
        snapshotView.frame = convertedFrame
        return snapshotView
    }

    private func presentMenuFromSourceView(_ sourceView: UIView) {
        menuController.modalPresentationStyle = .popover
        menuController.popoverPresentationController?.delegate = self
        menuController.popoverPresentationController?.sourceView = sourceView
        menuController.popoverPresentationController?.sourceRect = sourceView.bounds
        menuController.popoverPresentationController?.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        presentingController?.present(menuController, animated: true, completion: nil)
    }
    
    private func dimBackground() {
        UIView.animate(withDuration: dimmingDuration) {
            // swiftlint:disable:next discouraged_object_literal
            self.view.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.01568627451, blue: 0.05882352941, alpha: 0.5)
        }
    }
}

extension PopupMenuController: UIPopoverPresentationControllerDelegate
{
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        .none // prevents showing the popup in full screen
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        removeThisController()
    }
    
    func removeThisController() {
        UIView.animate(
            withDuration: dimmingDuration,
            animations: {
                self.view.backgroundColor = .clear
            }, completion: { _ in
                self.remove()
            })
    }
    
    func removeMenuController() {
        menuController.dismiss(animated: true)
    }
}
