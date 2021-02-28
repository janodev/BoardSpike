import Foundation

public protocol ApiClientProtocol {
    func request<T: Decodable>(_ resource: Resource, _ completion: @escaping ResultCallback<T>)
}
