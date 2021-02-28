// swiftlint:disable file_name
import Log
import Foundation
import Logging

let log: Logger = {
    var logger = Logger(label: "com.bikini.board.coredata")
    logger.logLevel = .debug
    return logger
}()
