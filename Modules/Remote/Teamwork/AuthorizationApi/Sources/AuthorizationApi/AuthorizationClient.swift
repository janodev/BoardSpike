import Foundation
import Networking

// swiftlint:disable force_unwrapping
private let teamworkURL = URL(string: "https://www.teamwork.com/")!

public struct Login {
    public let user: String
    public let password: String
    public init(user: String, password: String) {
        self.user = user
        self.password = password
    }
}

public final class AuthorizationClient: ApiClient
{
    let timeout = TimeInterval(20)
    
    public init(baseURL: URL) {
        super.init(baseURL: baseURL, session: AuthorizationClient.session())
    }
    
    /// Initializes with a default URL pointing to https://teamwork.com
    public convenience init() {
        self.init(baseURL: teamworkURL)
    }
    
    private static func session() -> URLSession {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "Accept": "application/json, text/plain, */*",
            "Content-Type": "application/json;charset=UTF-8"
        ]
        return URLSession(configuration: config)
    }
    
    internal func sync<T: Decodable>(_ resource: Resource?) -> Result<T, RequestError>
    {
        guard let resource = resource else { return Result<T, RequestError>.failure(RequestError.decodeJSONFailed) }
        let semaphore = DispatchSemaphore(value: 0)
        var response: Result<T, RequestError>?
        request(resource) { (result: Result<T, RequestError>) in
            response = result
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: .now() + timeout)
        return response ?? Result.failure(RequestError.timeout)
    }
}
