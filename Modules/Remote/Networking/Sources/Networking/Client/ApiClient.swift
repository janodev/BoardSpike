import Foundation
import os

open class ApiClient: ApiClientProtocol
{
    public var session: Session
    public let baseURL: URL

    public init(baseURL: URL, session: Session) {
        self.baseURL = baseURL
        self.session = session
    }

    // MARK: - Request

    public func request<T: Decodable>(_ resource: Resource?, _ completion: @escaping ResultCallback<T>)
    {
        guard let resource = resource else {
            completion(.failure(.encodeJSONFailed))
            return
        }
        request(resource, completion)
    }
    
    public func request<T: Decodable>(_ resource: Resource, _ completion: @escaping ResultCallback<T>)
    {
        guard let request = URLRequest(resource: resource, baseURL: baseURL) else {
            return complete(completion, .failure(.invalidEndpointDefinition(resource, baseURL)))
        }
        
        curl(request)
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if let error = error {
                log.warning("\(error)")
                self.complete(completion, .failure(RequestError.urlLoading(error)))
                return
            }
            let apiResult: Result<T, RequestError> = self.handleResponse(error, response, data)
            if case let .failure(error) = apiResult {
                log.warning("\(error)")
            }
            self.complete(completion, apiResult)
        })

        task.resume()
    }
    
    private func complete<T>(_ completion: @escaping ResultCallback<T>, _ result: Result<T, RequestError>){
        if case let .failure(error) = result {
            completion(.failure(error))
            return
        }
        completion(result)
    }
    
    // MARK: - Private Methods Request
    
    private func parseData<T: Decodable>(_ response: HTTPURLResponse, _ data: Data?) -> Result<T, RequestError>
    {
        if 200 ..< 300 ~= response.statusCode {
            log.debug("\nResponse: \(response.description) \n\nJSON:\n\(data.flatMap { $0.toJSON() } ?? "")")
            return self.parse(data)
        } else {
            log.warning("Response: \(response.description)")
            return .failure(.httpStatus(response.statusCode))
        }
    }

    private func handleResponse<T: Decodable>(_ error: Error?, _ response: URLResponse?, _ data: Data?) -> Result<T, RequestError>
    {
        var apiResult: Result<T, RequestError> = .failure(.noDataReturned)
        if let error = error {
            apiResult = .failure(.urlLoading(error))
        } else {
            guard let response = response as? HTTPURLResponse else {
                fatalError("Not an HTTP response")
            }
           apiResult = self.parseData(response, data)
        }

        return apiResult
    }

    // MARK: - Private Method Parsing Data

    private func parse<T: Decodable>(_ data: Data?) -> Result<T, RequestError>
    {
        guard let data = data else { return .failure(.decodeJSONFailed) }

        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let object = try decoder.decode(T.self, from: data)
            return .success(object)
        } catch let error as DecodingError {
            return .failure(.parsing(error))
        } catch {
            return .failure(.unexpected)
        }
    }
    
    private func curl(_ request: URLRequest)
    {
        let url = request.url?.absoluteString ?? ""
        
        let headers = ((session as? URLSession)?.configuration.httpAdditionalHeaders ?? [:])
            .map { key, value -> String in "-H '\(key): \(value)'" }
            .joined(separator: " \\\n")
        
        let method = request.httpMethod.flatMap { "-X \($0)" } ?? ""
        
        let body = request.httpBody.flatMap { String(data: $0, encoding: .utf8) } ?? ""
        
        let command = """
        \ncurl '\(url)' \\
        -v \\
        \(method) \\
        \(headers) \\
        -d '\(body)'
        """
        
        log.debug("\(command)")
    }
}

extension HTTPURLResponse {
    // swiftlint:disable:next override_in_extension
    override open var description: String {
        "\(statusCode) \(url?.absoluteString ?? "nil")"
    }
}

extension URLSession {
    // swiftlint:disable:next override_in_extension
    override open var description: String {
        if let headers = configuration.httpAdditionalHeaders {
            return "Session headers: \(headers)"
        }
        return "\(self)"
    }
}
