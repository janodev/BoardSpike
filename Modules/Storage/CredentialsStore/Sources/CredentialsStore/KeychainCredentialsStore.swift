import Foundation

public final class KeychainCredentialsStore: CredentialsStore, CustomStringConvertible
{
    @Keychain(account: "launchpad.apiEndPoint") private var apiEndPoint: String?
    @Keychain(account: "launchpad.accessToken") private var accessToken: String?

    public var credentials: Credentials? {
        get {
            guard let accessToken = accessToken, let apiEndPoint = apiEndPoint else { return nil }
            return Credentials(accessToken: accessToken, apiEndPoint: apiEndPoint)
        }
        set {
            apiEndPoint = newValue?.apiEndPoint
            accessToken = newValue?.accessToken
            log.debug("Notifying \(observers.count) observers")
            observers.forEach {
                log.debug("🐸 calling observer \($0 as Any)")
                $0(credentials)
            }
        }
    }
    
    public var hasAccessToken: Bool { credentials?.accessToken != nil }
    
    public init() {}
    
    // MARK: - CustomStringConvertible
    
    public var description: String {
        "KeychainCredentialsStore with \(observers.count) observers"
    }
    
    // MARK: -
    
    private var observers = [(Credentials?) -> Void]() {
        didSet {
            log.debug("Added observer on \(self)")
        }
    }
    
    public func addChangeObserver(observer: @escaping (Credentials?) -> Void) {
        observers.append(observer)
        log.debug("Observers is now \(observers.count): \(observers)")
    }
}
