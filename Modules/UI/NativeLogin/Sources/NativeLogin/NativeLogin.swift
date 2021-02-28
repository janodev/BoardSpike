import AuthorizationApi
import Coordinator
import CredentialsStore
import Foundation

class NativeLogin
{
    private weak var coordinator: RootCoordinator?
    private var credentialsStore: CredentialsStore
    
    init(coordinator: RootCoordinator,
         credentialsStore: CredentialsStore)
    {
        self.coordinator = coordinator
        self.credentialsStore = credentialsStore
    }
    
    func login(user: String, password: String)
    {
        do {
            try runSuccessPath(user: user, password: password)
        } catch {
            log.error("Error retrieving the value: \(error)")
        }
    }
    
    private func runSuccessPath(user: String, password: String) throws
    {
        let login = Login(user: user, password: password)
        let accounts = try AuthorizationClient().syncAccounts(login).get().accounts
        
        guard let firstAccount = accounts.first else {
            return /* user recognized but there are no accounts */
        }
        guard let baseURL = URL(string: firstAccount.installation.apiEndPoint) else {
            return /* the domain is not a valid URL */
        }
        
        let code = try AuthorizationClient(baseURL: baseURL).syncAuthenticationCode(login).get().code
        let response = try AuthorizationClient(baseURL: baseURL).syncAccessToken(code).get()
        credentialsStore.credentials = Credentials(
            accessToken: response.accessToken,
            apiEndPoint: response.installation.apiEndPoint
        )
        DispatchQueue.main.async {
            self.coordinator?.finish()
        }
    }
}
