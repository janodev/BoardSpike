import UIKit

final class NativeLoginViewController: UIViewController
{
    private let nativeLogin: NativeLogin

    init(nativeLogin: NativeLogin)
    {
        self.nativeLogin = nativeLogin
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView()
    {
        view = NativeLoginView { [weak self] loginData in
            DispatchQueue.global(qos: .background).async {
                self?.nativeLogin.login(user: loginData.login, password: loginData.password)
            }
        }
    }
}
