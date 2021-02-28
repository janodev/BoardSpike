import Foundation

public enum SessionProvider
{
    public static func createSessionClient(authorizationHeader: [String: String]? = nil) -> URLSession
    {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = authorizationHeader
        config.httpAdditionalHeaders?["Accept"] = "application/json"
        config.httpAdditionalHeaders?["Content-Type"] = "application/json;charset=UTF-8"
        return URLSession(configuration: config)
    }

    public static func createSessionForAuth() -> URLSession
    {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        return URLSession(configuration: config)
    }
}
