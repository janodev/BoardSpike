// swiftlint:disable

import CredentialsStore
import Foundation
import Logging

public typealias Dependencies = HasCredentialsStore

// swiftlint:disable implicitly_unwrapped_optional
public var container: Dependencies!

let log: Logger = {
    var logger = Logger(label: "com.bikini.board.nativelogin")
    logger.logLevel = .debug
    return logger
}()
