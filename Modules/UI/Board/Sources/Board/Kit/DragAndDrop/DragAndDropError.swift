
import Foundation

// Errors during drag and drop.
enum DragAndDropError: Error
{
    case wrongUTI
    case serializationError(Error)
    case deserializationError(Error)
}
