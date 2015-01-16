import UIKit

//テキストビュー
class ViewController: UIViewController, UITextViewDelegate {
    //定数
    let BTN_START = 0 //編集開始
    let BTN_END = 1   //編集完了
    let BTN_SHOW = 2  //表示
    
    //変数
    var _textView: UITextView? //テキストビュー

//====================
//UI
//====================
    //ロード完了時に呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        let dx: CGFloat = (UIScreen.mainScreen().bounds.size.width-320)/2
        
        //ビューの生成(黒い枠になる)
        let view = UIView(frame: CGRectMake(dx+10, 20, 300, 100))
        view.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(view)
        
        //テキストビューの生成
        _textView = makeTextView(CGRectMake(dx+11, 21, 298, 98),
            text: "これはテストです。")
        self.view.addSubview(_textView!)
        
        //編集開始ボタンの生成
        let btnStart = makeButton(CGRectMake(dx+15, 130, 90, 40),
            text: "編集開始", tag: BTN_START)
        self.view.addSubview(btnStart)
        
        //編集完了ボタンの生成
        let btnEnd = makeButton(CGRectMake(dx+115, 130, 90, 40),
            text: "編集完了", tag: BTN_END)
        self.view.addSubview(btnEnd)
        
        //表示ボタンの生成
        let btnShow = makeButton(CGRectMake(dx+215, 130, 90, 40),
            text: "表示", tag: BTN_SHOW)
        self.view.addSubview(btnShow)
    }
    
    //ボタンクリック時に呼ばれる
    func onClick(sender: UIButton) {
        if sender.tag == BTN_START {
            _textView?.becomeFirstResponder()
        } else if sender.tag == BTN_END {
            _textView?.resignFirstResponder()
        } else if sender.tag == BTN_SHOW {
            showAlert(nil, text: "テキストビューの文字列\n\(_textView!.text)")
        }
    }
    
    //テキストビューの生成(1)
    func makeTextView(rect: CGRect, text: String) -> UITextView {
        let textView = UITextView()
        textView.frame = rect
        textView.text = text
        textView.keyboardType = UIKeyboardType.Default
        textView.returnKeyType = UIReturnKeyType.Default
        textView.delegate = self
        return textView
    }
    
    //アラートの表示
    func showAlert(title: NSString?, text: NSString?) {
        let alert = UIAlertController(title: title, message: text,
            preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //テキストボタンの生成
    func makeButton(rect: CGRect, text: NSString, tag: Int)->UIButton {
        let button = UIButton.buttonWithType(UIButtonType.System) as UIButton
        button.frame = rect
        button.setTitle(text, forState: UIControlState.Normal)
        button.tag = tag
        button.addTarget(self, action: "onClick:",
            forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }
    
//====================
//UITextViewDelegate
//====================
    //テキスト変更時に呼ばれる(2)
    func textView(textView: UITextView,
        shouldChangeTextInRange range: NSRange,
        replacementText text: String) -> Bool {
        //最大140文字制限
        if countElements(textView.text) + countElements(text) > 140 {
            return false
        }
        return true
    }
}
