import Foundation

public final class SessionDataTaskStub: SessionDataTask {
    
    private let completionHandler: () -> Void
    
    public init(completionHandler: @escaping () -> Void) {
        self.completionHandler = completionHandler
    }
    
    public func resume() {
        completionHandler()
    }
}
