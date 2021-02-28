import Foundation
import Networking

public extension AuthorizationClient
{
    private func resource(_ login: Login) -> Resource? {
        Resource(
            path: "launchpad/v1/accounts.json",
            body: [
                "username": login.user,
                "email": login.user,
                "password": login.password,
                "rememberMe": false
            ],
            method: .POST,
            query: ["generic": "true"])
    }
    
    func accounts(_ login: Login, _ completion: @escaping ResultCallback<AccountsResponse>) {
        request(resource(login), completion)
    }
    
    func syncAccounts(_ login: Login) -> Result<AccountsResponse, RequestError> {
        sync(resource(login))
    }
}
