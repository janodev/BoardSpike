
import UIKit

struct LoginData
{
    let login: String
    let password: String
    init?(login: String?, password: String?)
    {
        guard let login = login, let password = password else { return nil }
        self.login = login
        self.password = password
    }
}

final class NativeLoginView: UIView
{
    private let user = UITextField()
    private let password = UITextField()
    private let stackView = UIStackView()
    private let signIn = UIButton()
    
    private var userPlaceholder = "user"
    private var passwordPlaceholder = "password"
    private var signInTitle = "Sign In"
    
    private let signInAction: (LoginData) -> Void
    
    init(signInAction: @escaping (LoginData) -> Void) {
        self.signInAction = signInAction
        super.init(frame: CGRect.zero)
        layout()
        
        user.text = "alejandro.ramirez@teamwork.com"
        password.text = "p4ssw0rd"
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout()
    {
        backgroundColor = .white
        signIn.backgroundColor = .cyan
        
        user.placeholder = userPlaceholder
        password.placeholder = passwordPlaceholder
        password.isSecureTextEntry = true
        signIn.setTitle(signInTitle, for: .normal)
        signIn.setTitleColor(.black, for: .normal)
        signIn.addTarget(self, action: #selector(signIn(sender:)), for: .touchUpInside)
        
        stackView.axis = .vertical
        stackView.spacing = 20
        
        stackView.addArrangedSubview(user)
        stackView.addArrangedSubview(password)
        addSubview(stackView)
        addSubview(signIn)
        
        [user, password, signIn, stackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 100),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 20),
            
            signIn.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 100),
            signIn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            signIn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            signIn.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    @objc
    func signIn(sender: UIButton) {
        LoginData(login: user.text, password: password.text).flatMap { [weak self] in
            self?.signInAction($0)
        }
    }
}
