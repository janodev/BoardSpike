import Coordinator
import CredentialsStore
import WebKit

final class LoginURLInterceptor: NSObject, WKNavigationDelegate
{
    private let ssoQueryCodeName = "code"
    private let url: URL
    private var credentialsStore: CredentialsStore
    private let coordinator: Coordinator?
    
    init(coordinator: Coordinator?,
         credentialsStore: CredentialsStore,
         url: URL)
    {
        self.coordinator = coordinator
        self.credentialsStore = credentialsStore
        self.url = url
    }
    
    func policy() -> WKNavigationActionPolicy
    {
        log.debug("Deciding on \(url)")
        
        if let code = AuthenticationCode(url).value() {
            log.debug("Got authentication callback with code \(code)")
            storeAccessToken(code)
            return .cancel
        }

        return .allow
    }

    private func storeAccessToken(_ code: String) {
        requestAccessToken(code: code) { credentials in
            log.debug("Server sent credentials: \(credentials as Any)")
            if let credentials = credentials {
                self.credentialsStore.credentials = credentials
                DispatchQueue.main.async {
                    self.coordinator?.finish()
                }
            }
        }
    }
    
    /// Returns the credentials object for the given authentication code.
    private func requestAccessToken(code: String, completion: @escaping (Credentials?) -> Void)
    {
        LaunchpadClient(authenticationCode: code).requestAccessToken { result in
            guard case .success(let response) = result else {
                completion(nil)
                return
            }
            completion(Credentials(accessToken: response.accessToken,
                                   apiEndPoint: response.installation.apiEndPoint))
        }
    }
}
