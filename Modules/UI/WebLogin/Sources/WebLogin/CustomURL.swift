
import Foundation

struct CustomURL
{
    private let scheme: String
    
    init(scheme: String) {
        self.scheme = scheme
    }
    
    func value() -> URL {
        // 'callback' is an arbitrary string, anything will do
        return URL(string: "\(scheme)://callback")!
    }
}
