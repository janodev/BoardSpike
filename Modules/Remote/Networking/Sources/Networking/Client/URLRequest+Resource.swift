import Foundation

extension URLRequest
{
    init?(resource: Resource, baseURL: URL)
    {
        guard let url = URLRequest.createURL(for: resource, relativeTo: baseURL) else {
            return nil
        }
        self.init(url: url)
        httpMethod = resource.method.rawValue
        httpBody = resource.body
        allHTTPHeaderFields = resource.additionalHeaders
    }

    private static func createURL(for resource: Resource, relativeTo baseURL: URL) -> URL?
    {
        let url = baseURL.appendingPathComponent(resource.path)
        guard !resource.query.keys.isEmpty else { return url }
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return nil
        }
        components.queryItems = resource.query.map { URLQueryItem(name: $0.0, value: $0.1) }
        return components.url
    }
}
