
import Logging
import UIKit

public struct PrintLogger: LogHandler {
    
    private var prettyMetadata: String?
    private let label: String
    
    public init(label: String) {
        
        self.label = label.components(separatedBy: ".").last ?? label
    }
    
    // MARK: - LogHandler
    
    public func log(level: Logger.Level,
                    message: Logger.Message,
                    metadata: Logger.Metadata?,
                    file: String,
                    function: String,
                    line: UInt) {

        let location = originOf(classOrigin: file) + "." + function
        let prefix = "[\(label)] "
        var msg = "\(prefix)" + resizeString(string: location, newLength: 40 - prefix.count)
        msg = msg + ":"
        msg = msg + StringUtils.padLeft(string: "\(line)", toLength: 3)
        msg = msg + " · "
        if !(metadata?.isEmpty ?? true) {
            
            msg = msg + (prettyMetadata ?? "") + " - "
        }
        msg = msg + levelDescription(level) + message.description
        print(msg)
    }
    
    public subscript(metadataKey metadataKey: String) -> Logger.Metadata.Value? {
        
        get { metadata[metadataKey] }
        set { metadata[metadataKey] = newValue }
    }
    
    public var metadata = Logger.Metadata() {
        
        didSet { prettyMetadata = prettify(metadata) }
    }
    
    public var logLevel = Logger.Level.debug

    // MARK: - Private

    private func levelDescription(_ level: Logger.Level) -> String {
        
        switch level {
            
        case .warning: return "⚠️ "
        case .error: return "🚨 "
        default: return ""
        }
    }
    
    private func originOf(classOrigin: Any?) -> String {
        
        var origin: String?
        if let classOrigin = classOrigin as? String {
            
            origin = NSURL(fileURLWithPath: classOrigin).deletingPathExtension?.lastPathComponent ?? ""
        } else if let any = classOrigin {
            
            if let clazz = object_getClass(any as AnyObject) {
                
                let className = NSStringFromClass(clazz)
                origin = (className as NSString).components(separatedBy: ".").last
            } else {
                
                origin = ""
            }
        }
        return origin ?? ""
    }
    
    private func resizeString(string: String, newLength: Int) -> String {
        
        let length = string.count
        if length < newLength {
            
            return StringUtils.padLeft(string: string, toLength: newLength)
        } else {
            
            let truncated = StringUtils.truncateTail(string: string, toLength: newLength)
            return StringUtils.replaceLastCharacter(string: truncated, character: "…")
        }
    }
    
    private func prettify(_ metadata: Logger.Metadata) -> String? {
        
        !metadata.isEmpty ? metadata.map { "\($0)=\($1)" }.joined(separator: " ") : nil
    }
}

private enum StringUtils {
    
    static func padLeft(string: String, toLength newLength: Int, withPad character: Character = " ") -> String {
        
        return pad(.left, string: string, toLength: newLength, withPad: character)
    }
    
    static func padRight(string: String, toLength newLength: Int, withPad character: Character = " ") -> String {
        
        return pad(.right, string: string, toLength: newLength, withPad: character)
    }
    
    static func replaceLastCharacter(string: String, character: Character) -> String {
        
        return replaceCharacter(string: string, character: character, side: Side.right)
    }

    static func truncateTail(string: String, toLength newLength: Int) -> String {
        
        return truncate(.right, string: string, toLength: newLength)
    }
    
    enum Side { case left, right }
    
    static func pad(_ side: Side, string: String, toLength newLength: Int, withPad character: Character = " ") -> String {
        
        let length = string.count
        guard newLength > length else {
            
            return string
        }
        let spaces = String(repeatElement(character, count: newLength - length))
        return side == .left ? spaces + string : string + spaces
    }
    
    static func truncate(_ dropSide: Side, string: String, toLength newLength: Int) -> String {
        
        let length = string.count
        guard newLength < length else {
            
            return string
        }
        if dropSide == .left {
            
            let offset = -1 * newLength + 1
            let index = string.index(string.endIndex, offsetBy: offset)
            return "…" + String(string.suffix(from: index))
        } else {
            
            let offset = newLength - 1
            let index = string.index(string.startIndex, offsetBy: offset)
            return String(string.prefix(upTo: index)) + "…"
        }
    }
    
    static func replaceCharacter(string: String, character: Character, side: Side) -> String {
        
        guard string.count > 1 else {
            
            return string
        }
        var newString = string
        switch side {
            
        case .left:
            newString.remove(at: newString.startIndex)
            return "\(character)\(newString)"
            
        case .right:
            newString.remove(at: newString.index(before: newString.endIndex))
            return "\(newString)\(character)"
        }
    }
}
