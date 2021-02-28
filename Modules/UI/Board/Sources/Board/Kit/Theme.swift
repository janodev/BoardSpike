
import UIKit

enum Theme
{
    enum Column
    {
        static let title = Font(font: UIFont.systemFont(ofSize: 14, weight: .bold), color: .darkBlue)
        static let background = UIColor.systemGray5
        static let link = Font(font: UIFont.systemFont(ofSize: 14), color: .link)
        static let footer = Font(font: UIFont.systemFont(ofSize: 13), color: UIColor.link)
        
        static func attributedTitle(_ text: String) -> NSAttributedString {
            Theme.attributed(text: text, font: title)
        }
        static func attributedLink(_ text: String) -> NSAttributedString {
            Theme.attributed(text: text, font: link)
        }
    }
    
    enum Task
    {
        static let background = UIColor.systemBackground
        static let code = Font(font: UIFont.systemFont(ofSize: 14), color: .secondaryLabel)
        static let iconTint = UIColor.iconColor
        static let tag = Font(font: UIFont.systemFont(ofSize: 12), color: .darkBlue)
        static var tagBackground: UIColor {
            [.greenTagColor, .yellowTagColor, .lightBlueTagColor, .purpleTagColor][Int.random(in: 0 ... 3)]
        }
        static let title = Font(font: UIFont.systemFont(ofSize: 14), color: .darkBlue)

        static func attributedCode(_ text: String) -> NSAttributedString {
            Theme.attributed(text: text, font: code)
        }
        static func attributedTitle(_ text: String) -> NSAttributedString {
            Theme.attributed(text: text, font: title)
        }
        static func attributedTag(_ text: String) -> NSAttributedString {
            Theme.attributed(text: text, font: tag)
        }
    }
    
    struct Font
    {
        let font: UIFont
        let color: UIColor
    }
    
    static let background = UIColor.white
    static let title = Font(font: UIFont.systemFont(ofSize: 20, weight: .semibold), color: .darkBlue)
    
    static func attributedTitle(_ text: String) -> NSAttributedString {
        Theme.attributed(text: text, font: title)
    }
    
    private static func attributed(text: String, font: Font) -> NSAttributedString
    {
        NSAttributedString(string: text, attributes: [
            .font: font.font,
            .foregroundColor: font.color
        ])
    }
}

private extension UIColor
{   // swiftlint:disable operator_usage_whitespace
    static let darkBlue = UIColor(displayP3Red: 20.0/255.0, green: 35.0/255.0, blue: 70.0/255.0, alpha: 1.0)
    static let greenTagColor = UIColor(displayP3Red: 124.0/255.0, green: 213.0/255.0, blue: 167.0/255.0, alpha: 0.8)
    static let yellowTagColor = UIColor(displayP3Red: 246.0/255.0, green: 200.0/255.0, blue: 68.0/255.0, alpha: 0.8)
    static let lightBlueTagColor = UIColor(displayP3Red: 185.0/255.0, green: 211.0/255.0, blue: 251.0/255.0, alpha: 0.8)
    static let purpleTagColor = UIColor(displayP3Red: 150.0/255.0, green: 140.0/255.0, blue: 212.0/255.0, alpha: 0.8)
    static let iconColor = UIColor(displayP3Red: 94.0/255.0, green: 166.0/255.0, blue: 226.0/255.0, alpha: 1.0)
}
