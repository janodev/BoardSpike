import Foundation
import Log
import Logging

let log: Logger = {
    var logger = Logger(label: "com.bikini.board.coordinator")
    logger.logLevel = .debug
    return logger
}()
