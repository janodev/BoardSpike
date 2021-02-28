// swiftlint:disable file_name
import Foundation
import Log
import Logging

let log: Logger = {
    var logger = Logger(label: "com.bikini.board.credentials")
    logger.logLevel = .debug
    return logger
}()
