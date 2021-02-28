
public protocol CredentialsStore
{
    var credentials: Credentials? { get set }
    var hasAccessToken: Bool { get }
    func addChangeObserver(observer: @escaping (Credentials?) -> Void)
}
