import UIKit

//Webビュー
class ViewController: UIViewController, UIWebViewDelegate {
    var _webView: UIWebView? //Webビュー
    
    //ロード完了時に呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Webビューの生成
        _webView = makeWebView(CGRectMake(0, 20,
            self.view.frame.width, self.view.frame.height-20))
        self.view.addSubview(_webView!)
        
        //インジケータの表示(2)
        UIApplication.sharedApplication(
            ).networkActivityIndicatorVisible = true
        
        //HTMLの読み込み(3)
        var url: NSURL = NSURL(string: "http://npaka.net")!
        var urlRequest: NSURLRequest = NSURLRequest(URL: url)
        _webView?.loadRequest(urlRequest)
    }
    
    //Webビューの生成
    func makeWebView(frame: CGRect) -> UIWebView {
        //Webビューの生成(1)
        let webView = UIWebView()
        webView.frame = frame
        webView.backgroundColor = UIColor.blackColor()
        webView.scalesPageToFit = true //ページをフィットさせるかどうか
        webView.autoresizingMask =     //ビューサイズの自動調整
            UIViewAutoresizing.FlexibleRightMargin |
            UIViewAutoresizing.FlexibleTopMargin |
            UIViewAutoresizing.FlexibleLeftMargin |
            UIViewAutoresizing.FlexibleBottomMargin |
            UIViewAutoresizing.FlexibleWidth |
            UIViewAutoresizing.FlexibleHeight
        webView.delegate = self
        return webView
    }
    
    //アラートの表示
    func showAlert(title: NSString?, text: NSString?) {
        let alert = UIAlertController(title: title, message: text,
            preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
//====================
//UIWebViewDelegate
//====================
    //HTML読み込み開始時に呼ばれる(4)
    func webView(webView: UIWebView, shouldStartLoadWithRequest
        request: NSURLRequest,
        navigationType: UIWebViewNavigationType) -> Bool {
        //クリック時
        if navigationType == UIWebViewNavigationType.LinkClicked ||
            navigationType == UIWebViewNavigationType.FormSubmitted {
            //通信中の時は再度URLジャンプさせない(5)
            if UIApplication.sharedApplication(
                ).networkActivityIndicatorVisible {
                return false
            }
                
            //インジケーターの表示(2)
            UIApplication.sharedApplication(
                ).networkActivityIndicatorVisible = true
        }
        return true
    }
    
    //HTML読み込み成功時に呼ばれる(4)
    func webViewDidFinishLoad(webView: UIWebView) {
        //インジケーターの非表示(2)
        UIApplication.sharedApplication(
            ).networkActivityIndicatorVisible = false
    }
    
    //HTML読み込み失敗時に呼ばれる(4)
    func webView(webView: UIWebView,
        didFailLoadWithError error: NSError) {
        //インジケーターの非表示(2)
        UIApplication.sharedApplication(
            ).networkActivityIndicatorVisible = false
    
        //アラート
        showAlert(nil, text: "通信失敗しました")
    }
}
