import Foundation

/// Protocol for reusable cells.
protocol Configurable
{
    associatedtype Model: Hashable, NSItemProviderReading, NSItemProviderWriting
    static var reuseIdentifier: String { get }
    func configure(_ model: Model)
}
