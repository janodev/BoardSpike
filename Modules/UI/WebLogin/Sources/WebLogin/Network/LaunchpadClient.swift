
import Foundation

public enum AttemptResult: CustomStringConvertible
{
    case networkError(Error)
    case httpError(Int)
    case emptyResponseError
    case malformedResponseError
    case success(LaunchpadResponse)
    
    public var description: String {
        switch self {
        case .networkError(let error): return "Error: network error \(error)"
        case .httpError(let code): return "Error: HTTP code \(code)"
        case .emptyResponseError: return "Error: the response is unexpectedly empty"
        case .malformedResponseError: return "Error: the response is malformed"
        case .success(let response): return "Success: response was \(response)"
        }
    }
}

public final class LaunchpadClient
{
    private let authenticationCode: String
    
    public init(authenticationCode: String) {
        self.authenticationCode = authenticationCode
    }
    
    private var session: URLSession {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        return URLSession(configuration: config)
    }
    
    private var accessTokenRequest: URLRequest {
        // swiftlint:disable force_unwrapping
        let tokenURL = URL(string: "https://www.teamwork.com/launchpad/v1/token.json")!
        var request = URLRequest(url: tokenURL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["code": authenticationCode], options: [])
        return request
    }
    
    public func requestAccessToken(completion: @escaping (AttemptResult) -> Void) {
        session.dataTask(with: accessTokenRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                completion(.networkError(error))
                return
            }
            // swiftlint:disable force_cast
            let httpStatus = (response as! HTTPURLResponse).statusCode
            guard 200...299 ~= httpStatus else {
                completion(.httpError(httpStatus))
                return
            }
            guard let data = data else {
                completion(.emptyResponseError)
                return
            }
            guard let launchpadResponse = try? JSONDecoder().decode(LaunchpadResponse.self, from: data) else {
                completion(.malformedResponseError)
                return
            }
            completion(.success(launchpadResponse))
        }
        .resume()
    }
}
