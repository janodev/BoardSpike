
import MobileCoreServices
import UIKit

/// Remove a table row when dropped.
final class RemoveRowDropDelegate<Source: DraggableSource>: NSObject & UIDropInteractionDelegate {
    
    // Called when a session enters the view, moves within the view, or receives another item while within the view.
    func dropInteraction(_: UIDropInteraction, sessionDidUpdate _: UIDropSession) -> UIDropProposal
    {
        // Possible proposals: move, copy, forbidden, cancel.
        // We are going to drop it in the trash, so the closest is ".move".
        return UIDropProposal(operation: .move)
    }

    // Passes the session of an item.
    func dropInteraction(_: UIDropInteraction, performDrop session: UIDropSession)
    {
        (session.localDragSession?.localContext as? DraggedCell<Source>)?.remove()
    }
}
