import Foundation
@testable import Networking

final class SessionStub: Session {
    
    let data: Data?
    let response: URLResponse?
    let error: Error?
    
    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> SessionDataTask {
        SessionDataTaskStub(completionHandler: { completionHandler(self.data, self.response, self.error) })
    }
}
