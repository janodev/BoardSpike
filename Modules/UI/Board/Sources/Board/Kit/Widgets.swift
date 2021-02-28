
import UIKit

enum Widgets
{
    static func alert(title: String,
                      ok: String = "OK",
                      cancel _: String = "Cancel",
                      okAction: @escaping (UIAlertController) -> Void) -> UIAlertController
    {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: nil)
        alertController.addAction(UIAlertAction(title: ok, style: .default, handler: { _ in
            okAction(alertController)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        return alertController
    }

    static func trashButton() -> UIButton
    {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .systemRed
        return button
    }
}
