import Foundation
@testable import Networking

final class SessionDataTaskStub: SessionDataTask {
    
    let completionHandler: () -> Void
    
    internal init(completionHandler: @escaping () -> Void) {
        self.completionHandler = completionHandler
    }
    
    func resume() {
        completionHandler()
    }
}
