import Foundation

public protocol ApiRequest: Encodable {
    associatedtype Response: Decodable

    /// last part of the URL
    var resourceName: String { get }
}
