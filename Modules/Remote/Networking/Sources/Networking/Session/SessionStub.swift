import Foundation

public final class SessionStub: Session
{
    private let data: Data?
    private let response: URLResponse?
    private let error: Error?
    
    public init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
    
    public func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> SessionDataTask {
        SessionDataTaskStub(completionHandler: { completionHandler(self.data, self.response, self.error) })
    }
}
