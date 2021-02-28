// swiftlint:disable

import CredentialsStore
import Foundation
import Logging

public typealias Dependencies = HasCredentialsStore

// swiftlint:disable implicitly_unwrapped_optional
private var _container: Dependencies!

public var container: Dependencies {
    get {
        precondition(_container != nil, "Container is nil. Inject this variable before using the module.")
        return _container
    }
    set {
        _container = newValue
    }
}

let log: Logger = {
    var logger = Logger(label: "com.bikini.board.weblogin")
    logger.logLevel = .debug
    return logger
}()
