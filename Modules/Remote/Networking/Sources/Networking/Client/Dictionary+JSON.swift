import Foundation

public extension Dictionary where Key == String, Value == Any
{
    func toJSON() -> Any? {
        toJSONData().flatMap {
            try? JSONSerialization.jsonObject(with: $0, options: [])
        }
    }
    func toJSONData() -> Data? {
        try? JSONSerialization.data(withJSONObject: self, options: [])
    }
}
