
import Board
import CredentialsStore
import Foundation
import Log
import Logging
import NativeLogin
import Networking
import TeamworkApi
import WebLogin

public typealias Dependencies = HasCredentialsStore & HasTeamworkClient & HasLogger

public var container: Dependencies = {
    let newContainer = ContainerFactory.newInstance()
    NativeLogin.container = newContainer
    WebLogin.container = newContainer
    Board.container = newContainer
    return newContainer
}()

var log: Logger { container.logger }

private enum ContainerFactory
{
    static func newInstance() -> Dependencies
    {
        let newContainer = Container(credentialsStore: build(), logger: build())
        newContainer.credentialsStore.addChangeObserver { [weak newContainer, observe] credentials in
            guard let unwrappedContainer = newContainer else { return }
            observe(unwrappedContainer, credentials)
        }
        return newContainer
    }
    
    private static func build() -> CredentialsStore {
        KeychainCredentialsStore()
    }
    
    private static func build() -> Logger {
//        let handlerFactory = OSLogLogger.factory()
//        LoggingSystem.bootstrap(handlerFactory)
        LoggingSystem.bootstrap(PrintLogger.init)
        var logger = Logger(label: "com.bikini.board.app")
        logger.logLevel = .debug
        return logger
    }

    private static func observe(_ container: Container, _ credentials: Credentials?) {
        if let credentials = credentials {
            log.debug("Initializing the TeamWorkClient")
            let authProvider = AuthorizationProvider(apiEndPoint: credentials.apiEndPoint, accessToken: credentials.accessToken)
            container.teamworkClient = TeamWorkClient(authProvider: authProvider)
        } else {
            log.debug("Dropping the TeamWorkClient")
            container.teamworkClient = nil
        }
    }
}

public class Container: Dependencies, CustomStringConvertible
{
    public var credentialsStore: CredentialsStore
    public var teamworkClient: TeamWorkClientProtocol?
    public var logger: Logger
    
    // MARK: - CustomStringConvertible
    
    public var description: String {
        """
        Container
            credentialsStore: \(credentialsStore)
            teamworkClient: \(teamworkClient as Any)
            logger: \(logger)
        """
    }
    
    // MARK: - Factory
    
    init(credentialsStore: CredentialsStore, logger: Logger) {
        self.credentialsStore = KeychainCredentialsStore()
        self.logger = Logger(label: "com.bikini.board.app")
    }
}
