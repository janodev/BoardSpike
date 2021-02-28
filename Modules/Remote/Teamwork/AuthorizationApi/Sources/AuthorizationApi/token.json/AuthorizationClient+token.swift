import Foundation
import Networking

public extension AuthorizationClient
{
    private func resource(_ authenticationCode: String) -> Resource? {
        Resource(path: "launchpad/v1/token.json",
                 body: ["code": authenticationCode],
                 method: .POST)
    }
    
    func accessToken(
        authenticationCode: String,
        completion: @escaping ResultCallback<AccessTokenResponse>)
    {
        request(resource(authenticationCode), completion)
    }
    
    func syncAccessToken(_ authenticationCode: String) -> Result<AccessTokenResponse, RequestError> {
        sync(resource(authenticationCode))
    }
}
