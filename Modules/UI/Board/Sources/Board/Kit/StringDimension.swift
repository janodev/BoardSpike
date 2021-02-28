
import UIKit

enum StringDimension
{
    static func heightUsingBoundingRect(for string: String, font: UIFont, width: CGFloat) -> CGFloat
    {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = string.boundingRect(with: constraintRect,
                                              options: .usesLineFragmentOrigin,
                                              attributes: [NSAttributedString.Key.font: font],
                                              context: nil)
        return ceil(boundingBox.height)
    }
    
    static func heightUsingBoundingRect(for string: String, withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = string.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    
    static func widthUsingBoundingRect(for string: String, withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = string.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.width)
    }
    
    // - unused

    static func heightUsingTextStorage(for string: String, font: UIFont, width: CGFloat, lineFragmentPadding: CGFloat = 0.0) -> CGFloat
    {
        let textStorage = NSTextStorage(string: string)
        return heightUsingTextStorage(for: textStorage,
                                      font: font,
                                      width: width,
                                      lineFragmentPadding: lineFragmentPadding)
    }

    static func heightUsingTextStorage(for attributedString: NSAttributedString, font: UIFont, width: CGFloat, lineFragmentPadding: CGFloat = 0.0) -> CGFloat
    {
        let textStorage = NSTextStorage(attributedString: attributedString)
        return heightUsingTextStorage(for: textStorage,
                                      font: font,
                                      width: width,
                                      lineFragmentPadding: lineFragmentPadding)
    }

    // This may return unexpected results if the object that displays the text has a different lineFragmentPadding than this method uses.
    private static func heightUsingTextStorage(for textStorage: NSTextStorage, font: UIFont, width: CGFloat, lineFragmentPadding: CGFloat) -> CGFloat
    {
        let textContainter = NSTextContainer(size: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainter)
        textStorage.addLayoutManager(layoutManager)
        textStorage.addAttribute(NSAttributedString.Key.font, value: font, range: NSRange(location: 0, length: textStorage.length))
        textContainter.lineFragmentPadding = lineFragmentPadding
        layoutManager.glyphRange(for: textContainter)
        return layoutManager.usedRect(for: textContainter).size.height
    }
}
