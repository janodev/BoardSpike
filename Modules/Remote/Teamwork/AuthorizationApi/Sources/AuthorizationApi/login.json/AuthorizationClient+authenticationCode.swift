import Foundation
import Networking

public extension AuthorizationClient
{
    private func resource(_ login: Login) -> Resource? {
        Resource(path: "launchpad/v1/login.json",
                 body: ["username": login.user, "email": login.user, "password": login.password],
                 method: .POST,
                 query: ["appAuth": "true"])
    }
    
    func authenticationCode(
        _ login: Login,
        completion: @escaping ResultCallback<AuthenticationCodeResponse>)
    {
        request(resource(login), completion)
    }
    
    func syncAuthenticationCode(_ login: Login) -> Result<AuthenticationCodeResponse, RequestError> {
        sync(resource(login))
    }
}
