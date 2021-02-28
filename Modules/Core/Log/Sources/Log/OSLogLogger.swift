import Foundation
import Logging
import os

/*
 A LogHandler backend for swift-log.
 
 Usage:
 ```
 let handlerFactory = OSLogLogger.factory(osLogCategory: "launchpad")
 LoggingSystem.bootstrap(handlerFactory)
 let logger = Logger(label: "my.app.projects")
 ```
 
 The label will be the subsystem, the string you pass to the factory will be the category.
 If you want to log a private os_log message, include metadata["privacy"]="private".
 */
public struct OSLogLogger: LogHandler {
    
    private let label: String
    private let oslogger: OSLog
    private var prettyMetadata: String?
    
    // MARK: - Initializer

    /**
       Returns a factory for a log handler.
     
       This factory creates a os_log appender instance where the subsystem is the
       Logger 'label' and the category is the given argument.
       For instance, if you initialize the log with
       ```
       let handlerFactory = OSLogLogger.factory(osLogCategory: "launchpad")
       LoggingSystem.bootstrap(handlerFactory)
       var logger = Logger(label: "com.teamwork.mobile.projects.data")
       ```
       the subsystem is "com.teamwork.data" and the category is "data".
    */
    public static func factory(osLogCategory: String) -> (String) -> OSLogLogger {
        // swiftlint:disable:next opening_brace superfluous_disable_command
        { OSLogLogger(label: $0, category: osLogCategory) }
    }
    
    /**
       Returns a factory for a log handler.
     
       This factory creates a os_log appender instance where the subsystem is the
       Logger 'label' and the category is the last dot-separated component of the label.
       For instance, if you initialize the log with
       ```
       let handlerFactory = OSLogLogger.factory()
       LoggingSystem.bootstrap(handlerFactory)
       var logger = Logger(label: "com.teamwork.mobile.projects.data")
       ```
       the subsystem is "com.teamwork.data" and the category is "data".
    */
    public static func factory() -> (String) -> OSLogLogger {
        // swiftlint:disable:next opening_brace superfluous_disable_command
        { OSLogLogger(label: $0, category: $0.components(separatedBy: ".").last ?? $0 ) }
    }
    
    private init(label: String, category: String) {
        
        self.label = label
        self.oslogger = OSLog(subsystem: label, category: category)
    }
    
    // MARK: - LogHandler
    
    public var logLevel = Logger.Level.warning
    
    public var metadata = Logger.Metadata() {
        didSet { prettyMetadata = prettify(metadata) }
    }

    public subscript(metadataKey metadataKey: String) -> Logging.Logger.Metadata.Value? {
        get { metadata[metadataKey] }
        set { metadata[metadataKey] = newValue }
    }

    // swiftlint:disable function_parameter_count
    public func log(level: Logging.Logger.Level,
                    message: Logging.Logger.Message,
                    metadata: Logging.Logger.Metadata?,
                    file: String,
                    function: String,
                    line: UInt) {
        
        let msgMetadata = metadata.flatMap {
            
            prettify(self.metadata.merging($0, uniquingKeysWith: { _, new in new }))
        } ?? self.prettyMetadata
        
        let isPrivate = (metadata?["privacy"] ?? self.metadata["privacy"]) == "private"
        let fullMessage = "\(function):\(line) - \(level):\(msgMetadata.map { " \($0)" } ?? "") \(message)\n"
        
        if isPrivate {
            
            os_log("%{private}@", log: oslogger, type: map(level), fullMessage)
        } else {
            
            os_log("%{public}@", log: oslogger, type: map(level), fullMessage)
        }
    }
    
    private func map(_ level: Logging.Logger.Level) -> OSLogType {
        
        switch level {
            
        case .trace:    return .debug
        case .debug:    return .debug
        case .info:     return .info
        case .notice:   return .info
        case .warning:  return .default
        case .error:    return .error
        case .critical: return .fault
        }
    }
    
    private func prettify(_ metadata: Logging.Logger.Metadata) -> String? {
        
        !metadata.isEmpty ? metadata.map { "\($0)=\($1)" }.joined(separator: " ") : nil
    }
}
