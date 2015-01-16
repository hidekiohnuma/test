import UIKit

//HTTP通信
class ViewController: UIViewController, UITextFieldDelegate {
    //定数
    let URL_TEST = "http://npaka.net/iphone/test.txt" //URL
    let BTN_READ = 0 //読み込み
    
    //変数
    var _textField: UITextField?             //テキストフィールド
    var _indicator: UIActivityIndicatorView? //インジケータ
    
//====================
//UI
//====================
    //ロード完了時に呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        let dx: CGFloat = (UIScreen.mainScreen().bounds.size.width-320)/2
        
        //テキストフィールドの生成
        _textField = makeTextField(CGRectMake(dx+10, 20, 300, 32), text: "")
        self.view.addSubview(_textField!)
        
        //読み込みボタンの生成
        let btnRead = makeButton(CGRectMake(dx+110, 62, 100, 40),
            text: "読み込み", tag: BTN_READ)
        self.view.addSubview(btnRead)
        
        //インジケーターの生成(2)
        _indicator = UIActivityIndicatorView()
        _indicator!.frame = CGRectMake(dx+140, 140, 40, 40)
        _indicator!.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.Gray
        _indicator!.hidesWhenStopped = true
        self.view.addSubview(_indicator!)
    }
    
    //テキストフィールドの生成
    func makeTextField(frame: CGRect, text: String) -> UITextField {
        let textField = UITextField()
        textField.frame = frame
        textField.text = text
        textField.borderStyle = UITextBorderStyle.RoundedRect
        textField.keyboardType = UIKeyboardType.Default
        textField.returnKeyType = UIReturnKeyType.Done
        textField.delegate = self
        return textField
    }
    
    //テキストボタンの生成
    func makeButton(frame: CGRect, text: NSString, tag: Int) -> UIButton {
        let button = UIButton.buttonWithType(UIButtonType.System) as UIButton
        button.frame = frame
        button.setTitle(text, forState: UIControlState.Normal)
        button.tag = tag
        button.addTarget(self, action: "onClick:",
            forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }
    
    //ボタンクリック時に呼ばれる
    func onClick(sender: UIButton) {
        if sender.tag == BTN_READ {
            http2data(URL_TEST)
        }
    }

//====================
//HTTP通信
//====================
    //バイト配列を文字列に変換
    func data2str(data: NSData) -> NSString {
        return NSString(data: data, encoding: NSUTF8StringEncoding)!
    }
    
    //HTTP通信
    func http2data(url: String) {
        //インジケーターのアニメーションの開始(3)
        _indicator?.startAnimating()
        
        //HTTP通信(1)
        let URL = NSURL(string: url)!
        let request = NSURLRequest(URL: URL)
        NSURLConnection.sendAsynchronousRequest(request,
            queue: NSOperationQueue.mainQueue(),
            completionHandler: self.fetchResponse)
    }
    
    //レスポンス受信時に呼ばれる
    func fetchResponse(res: NSURLResponse!, data: NSData!, error: NSError!) {
        //UIの更新
        if error == nil {
            _textField!.text = data2str(data)
        } else {
            _textField!.text = "通信エラー"
        }
        
        //インジケーターのアニメーションの停止(3)
        _indicator?.stopAnimating()
    }
}
