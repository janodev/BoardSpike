import Foundation
import os.log

/*
 Represents the authentication code passed to the application after successful SSO.
 
 The last step of a successful SSO authentication with Google invokes the application via URL.
 This URL will contain a query item named 'code', whose value is the access token that grants access to the API.
 
 The URL will be similar to this (scheme and path may vary):
 
     https://testingtheiosappwithanemptyprojectinc.eu.teamwork.com/launchpad/tokenauth?code=751709d6-5b72-4967-9988-d946b58598fa&continue=
     stnicholashospital://callback?code=6b3c8a28-cafe-87ab-babe-7c4053bec88b

 */
public class AuthenticationCode
{
    private let url: URL
    private let codeQueryItemName = "code" // arbitrary string defined by Google SSO
    
    /// - Param invocationURL: URL that invoked this application.
    public init(_ invocationURL: URL) {
        self.url = invocationURL
    }
    
    /// - Returns: the authentication code in the URL (if any)
    public func value() -> String?
    {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        let firstQueryItem = components?.queryItems?.first
        guard firstQueryItem?.name == codeQueryItemName else {
            // log.debug("This URL doesn’t contain a 'code' query item")
            return nil
        }
        
        guard let authenticationCode = firstQueryItem?.value else {
            // log.debug("The custom URL didn’t contain a value for the 'code' query item")
            return nil
        }
        
        return authenticationCode
    }
}
