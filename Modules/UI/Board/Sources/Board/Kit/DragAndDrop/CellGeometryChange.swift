import Foundation

extension Notification.Name
{
    static var ColumnWidthChange: Notification.Name {
        .init(rawValue: "ColumnWidthChange")
    }
    static var DragSessionWillBegin: Notification.Name {
        .init(rawValue: "DragSessionWillBegin")
    }
}
