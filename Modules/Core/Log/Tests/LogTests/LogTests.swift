@testable import Log
import Logging
import XCTest

final class LogTests: XCTestCase
{
    func testExample()
    {
        let handlerFactory = OSLogLogger.factory(osLogCategory: "tests")
        LoggingSystem.bootstrap(handlerFactory)
        
        let log = Logger(label: "com.bikini.log")
        log.trace("a trace message")
        log.debug("a debug message")
        log.info("an info message")
        log.info("a notice message")
        log.warning("a warning message")
        log.error("a error message")
        log.critical("a critical message")
    }

    static var allTests = [
        ("testExample", testExample)
    ]
}
