import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    // MARK:- Property
    @IBOutlet weak var webview: WKWebView!
    @IBOutlet weak var prevPageBtn: UIButton!
    @IBOutlet weak var nextPageBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var safariBtn: UIButton!
    @IBOutlet weak var bottomFuncBarConstraintH: NSLayoutConstraint!
    @IBOutlet weak var progressView: UIProgressView!
    
    private var curUrlStr:String!
    var titleStr:String!
    var urlStr:String!
    
    // MARK:- Init Flow
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        self.initData()
    }
    
    private func initView() {
        self.navigationItem.title = self.titleStr
        self.webview.navigationDelegate = self
        self.webview.uiDelegate = self
        
        self.webview.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    private func initData() {
        self.curUrlStr = self.urlStr
        
        self.loadUrl(urlStr: self.urlStr)
    }
    
    private func loadUrl(urlStr:String) {
        guard let url = URL(string: urlStr) else {
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        self.webview.load(urlRequest)
    }
    
    // MARK:- onPrevPageBtnClicked
    @IBAction func onPrevPageBtnClicked(_ sender: Any) {
        self.webview.goBack()
    }
    
    // MARK:- onNextPageBtnClicked
    @IBAction func onNextPageBtnClicked(_ sender: Any) {
        self.webview.goForward()
    }
    
    // MARK:- onReloadBtnClicked
    @IBAction func onReloadBtnClicked(_ sender: Any) {
        self.webview.reload()
    }
    
    // MARK:- onSafariBtnClicked
    @IBAction func onSafariBtnClicked(_ sender: Any) {
        CommonUtils.openUrl(urlStr: self.curUrlStr)
    }
    
    // MARK:- observeValueForKeyPath
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "estimatedProgress") {
            self.progressView.isHidden = (self.webview.estimatedProgress == 1)
            
            self.progressView.setProgress(Float(self.webview.estimatedProgress), animated: true)
        }
    }
    
    // MARK:- WKNavigationDelegate
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {}
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
        
        guard let urlStr = webView.url?.absoluteString.removingPercentEncoding,
              !urlStr.isEmpty else {
            print("url is nil")
            return
        }
        
        self.curUrlStr = urlStr
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.prevPageBtn.isEnabled = self.webview.canGoBack
        self.nextPageBtn.isEnabled = self.webview.canGoForward
        
        self.progressView.setProgress(0.0, animated: false)
    }
    
    private func webView(webView: WKWebView!, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError!) {
        // FIXME: Fail not implemented
    }
}
