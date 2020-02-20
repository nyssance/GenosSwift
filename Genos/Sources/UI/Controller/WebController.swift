//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

import WebKit

open class WebController: BaseController, WKNavigationDelegate, WKUIDelegate, BackBarButtonItemDelegate {
    // MARK: - 🍀 属性

    public var link = ""
    public var data = ""

    public var webView: WKWebView!
    var textLayer: CATextLayer!
    public var backButton: UIBarButtonItem!
    public var forwardButton: UIBarButtonItem!
    public var refreshButton: UIBarButtonItem!
    public var closeBarButton: UIBarButtonItem!

    var observation: NSKeyValueObservation!

    // MARK: - 💖 生命周期 (Lifecycle)

    // swiftlint:disable function_body_length
    public final override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: 1. 识别再链出去的标题, 2. 增加再链出去的返回功能
        let config = WKWebViewConfiguration().apply {
            // SO https://stackoverflow.com/questions/40884138/error-when-using-wkaudiovisualmediatypenone-in-swift-3
            $0.mediaTypesRequiringUserActionForPlayback = []
        }
        webView = WKWebView(frame: view.frame, configuration: config).apply { it in
            UIWebView().stringByEvaluatingJavaScript(from: "navigator.userAgent")?.let {
                it.customUserAgent = "\($0) CM.Genos.iOS/\(InfoPlistUtil.APP_VERSION)" // TODO: 改为appbunle
            }
            if navigationController != nil {
                navigationItem.largeTitleDisplayMode = .never
                edgesForExtendedLayout = []
                it.frame.size.height = webView.frame.height - topBarHeight
                it.scrollView.clipsToBounds = false // 上滑时导航栏保持半透明效果
            }
            it.navigationDelegate = self
            it.uiDelegate = self
        }
        observation = webView.observe(\.estimatedProgress) { _, _ in
            func isHttp(_ url: URL?) -> Bool {
                switch url?.scheme {
                case "http", "https", "about":
                    return true
                default:
                    return false
                }
            }

            if isHttp(self.webView.url) {
                self.progressView.setProgress(Float(self.webView.estimatedProgress), animated: true)
                if self.webView.estimatedProgress == 1 {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) { // 必须延时, 否则scrollView的背景色在渲染比较慢的网页还会被设置回去
                        self.progressView.setProgress(0, animated: false)
                        self.webView.scrollView.backgroundColor = .clear
                    }
                }
            }
        }
        view.backgroundColor = .colorWithHex(0x2E3132)
        view.addSubview(webView)
        // 背景
        textLayer = CATextLayer().apply { it in
            it.fontSize = UIFont.systemFontSize
            it.contentsScale = UIScreen.main.scale
            it.alignmentMode = CATextLayerAlignmentMode.center
        }
        view.layer.insertSublayer(textLayer, at: 0)
        do { // 导航栏和工具栏
            if isDebug {
                navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(icon: .fontAwesomeSolid(.ellipsisH), size: .appBarIcon), style: .plain, target: self, action: #selector(more))
            }
            backButton = UIBarButtonItem(image: UIImage(icon: .fontAwesomeSolid(.chevronLeft), size: .appBarIcon), style: .plain, target: self, action: #selector(back))
            forwardButton = UIBarButtonItem(image: UIImage(icon: .fontAwesomeSolid(.chevronRight), size: .appBarIcon), style: .plain, target: self, action: #selector(forward))
            // backButton.setIcon(icon: .fontAwesomeSolid(.chevronRight), iconSize: iconSize, color: .black)
            refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
            let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            setToolbarItems([space, backButton, space, forwardButton, space, refreshButton], animated: false)
            navigationController?.isToolbarHidden = false
            closeBarButton = UIBarButtonItem(title: "close".locale, style: .plain, target: self, action: #selector(cancel))
            navigationItem.leftItemsSupplementBackButton = true
        }
        if link.isBlank { // 没有link, 加载字符串
            webView.loadHTMLString(data, baseURL: nil)
        } else if let url = URL(string: link) {
            switch url.scheme.orEmpty() {
            case "http", "https":
                // SO https://stackoverflow.com/questions/26573137/can-i-set-the-cookies-to-be-used-by-a-wkwebview
                let cookies = HTTPCookieStorage.shared.cookies(for: url) ?? []
                cookies.forEach { it in
                    log.error("\(it.name)")
                    webView.configuration.websiteDataStore.httpCookieStore.setCookie(it)
                }
            case "file":
                link = Bundle.main.path(forResource: url.path, ofType: "html") ?? link
                do {
                    data = try String(contentsOfFile: link, encoding: .utf8)
                } catch {
                    log.error("加载 \(link) 失败: \(error)")
                }
                webView.loadHTMLString(data, baseURL: URL(string: link))
            default:
                break
            }
        }
    }

    // swiftlint:enable function_body_length

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setBackBarButtonItem(title: "") // 默认从WebController跳出去的都没有返回键
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isToolbarHidden = true
    }

    // MARK: - 💛 Action

    @objc
    public func more() {
        // let options = [UIApplicationOpenURLOptionUniversalLinksOnly : true]
        // UIApplication.shared.open(url, options: options)
        URL(string: link)?.let {
            UIApplication.shared.open($0)
        }
    }

    @objc
    public func back() {
        webView.goBack()
    }

    @objc
    public func forward() {
        webView.goForward()
    }

    @objc
    public func refresh() {
        webView.url?.let {
            webView.load(URLRequest(url: $0))
        }
    }

    // MARK: - 🔹 WKNavigationDelegate

    //    public func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
    //        if let trust = challenge.protectionSpace.serverTrust { // 处理网页http跳转
    //            completionHandler(.useCredential, URLCredential(trust: trust))
    //        }
    //    }

    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else { return }
        //        if let url = navigationAction.request.url {
        if ["http", "https", "about"].contains(url.scheme.orEmpty()) {
            url.host?.let { host in
                if let webHostTexts = WEB_HOST_TEXTS {
                    let hosts = Array(webHostTexts.keys).filter { $0.contains(host) }
                    if let key = hosts.first {
                        textLayer.string = webHostTexts[key]
                    } else {
                        textLayer.string = host
                    }
                } else {
                    textLayer.string = host
                }
                let textSize = ((textLayer.string as? String) ?? host).size(font: .systemFont)
                textLayer.bounds = CGRect(origin: .zero, size: CGSize(width: view.frame.width - getTheme().padding * 2, height: textSize.height))
                textLayer.frame.origin = CGPoint(x: (SCREEN_WIDTH - textLayer.bounds.width) / 2, y: getTheme().padding)
            }
        } else {
            navigateTo(url.absoluteString)
        }
        //        }
        decisionHandler(.allow)
    }

    //    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
    //        //TODO 处理跨域
    //    }

    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation) {
        backButton.isEnabled = webView.canGoBack
        forwardButton.isEnabled = webView.canGoForward
    }

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
        backButton.isEnabled = webView.canGoBack
        forwardButton.isEnabled = webView.canGoForward
        title = title ?? webView.title // TODO: 第二层title不显示
        if webView.canGoBack {
            navigationItem.leftBarButtonItem = closeBarButton
        }
    }

    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation, withError error: Error) {
        if (error as NSError).code != URLError.cancelled.rawValue { // 跳新页面不提示错误
            showAlert(error.localizedDescription)
        }
    }

    // MARK: 🔹 WKUIDelegate

    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        showAlert(message)
        completionHandler()
    }

    public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let action = UIAlertAction(title: "ok".locale, style: .default) { _ in
            completionHandler(true)
        }
        showAlert(message, action: action) { _ in
            completionHandler(false)
        }
    }

    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        webView.load(navigationAction.request)
        return nil
    }

    // MARK: - 💛 BackBarButtonItemDelegate

    public func shouldPopOnBackBarButtonItem() -> Bool {
        if webView.canGoBack {
            webView.goBack()
        }
        return !webView.canGoBack
    }
}
