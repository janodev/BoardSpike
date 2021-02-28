import Coordinator
import CredentialsStore
import os.log
import SafariServices
import UIKit
import WebKit

// swiftlint:disable:next force_unwrapping
private let loginUrl = URL(string: "https://www.teamwork.com/launchpad/login")!

final class LoginWebViewController: UIViewController
{
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        webView.navigationDelegate = self
        return webView
    }()
    private weak var coordinator: RootCoordinator?
    private var credentialsStore: CredentialsStore
    private var urlScheme: String
    
    init(coordinator: RootCoordinator,
         credentialsStore: CredentialsStore,
         urlScheme: String)
    {
        self.coordinator = coordinator
        self.credentialsStore = credentialsStore
        self.urlScheme = urlScheme
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loginURL().flatMap(loadPage)
    }

    private func loginURL() -> URL?
    {
        let anyRandomString = "callback"
        var components = URLComponents(url: loginUrl, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: urlScheme, value: anyRandomString)]
        guard let url = components?.url else {
            log.error("Can’t load the login page because it is malformed. Query item: \(urlScheme) \(anyRandomString)")
            return nil
        }
        return url
    }
    
    func loadPage(url: URL){
        log.debug("Loading initial URL \(url.absoluteString)")
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

extension LoginWebViewController: WKNavigationDelegate
{
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
    {
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }
        let policy = LoginURLInterceptor(
            coordinator: coordinator,
            credentialsStore: credentialsStore,
            url: url).policy()
        decisionHandler(policy)
    }
}
