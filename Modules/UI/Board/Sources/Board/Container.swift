
import AuthorizationApi
import CredentialsStore
import Foundation
import Log
import Logging
import Networking
import TeamworkApi

public typealias Dependencies = HasCredentialsStore & HasTeamworkClient

// swiftlint:disable implicitly_unwrapped_optional
public var container: Dependencies!

let log: Logger = {
    var logger = Logger(label: "com.bikini.board.board")
    logger.logLevel = .debug
    return logger
}()
