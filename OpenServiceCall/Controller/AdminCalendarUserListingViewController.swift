
import UIKit
import WebKit

class AdminCalendarUserListingViewController: UIViewController, WKUIDelegate {

    var webView: WKWebView!

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        rightBarButtonClicked()

        let myUrl = URL(string: "http://rlhosting.co.in/tnt/public/webview/calendar")
        let myRequest = URLRequest(url: myUrl!)
        webView.load(myRequest)

    }
    
}
