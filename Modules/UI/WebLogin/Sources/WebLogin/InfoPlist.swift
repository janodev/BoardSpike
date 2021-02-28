
import Foundation
import os.log

/// Represents the Info.plist.
public struct InfoPlist
{
    public init(){}
    
    /// Returns the custom URL schemes registered by the app ('CFBundleURLSchemes' array).
    public func bundleURLSchemes() -> [String]
    {
        guard let path = Bundle.main.path(forResource: "Info", ofType: "plist") else {
            log.error("Can’t find path to Info.plist in the main bundle.")
            return []
        }
        guard
            let infoDict = NSDictionary(contentsOfFile: path) as? [String: AnyObject],
            let anyDictionary = (infoDict["CFBundleURLTypes"] as? [[String: Any]])?.first,
            let urlSchemes = anyDictionary["CFBundleURLSchemes"] as? [String]
        else {
            log.error("Can’t find path to CFBundleURLSchemes in the Info.plist.")
            return []
        }
        return urlSchemes
    }
}
