import UIKit

//プリファレンスの読み書き
class ViewController: UIViewController, UITextFieldDelegate {
    //定数
    let BTN_WRITE = 0 //書き込み
    let BTN_READ = 1  //読み込み
    
    //変数
    var _textField: UITextField? //テキストフィールド
    
//====================
//UI
//====================
    //ロード完了時に呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        let dx: CGFloat = (UIScreen.mainScreen().bounds.size.width-320)/2
        
        //テキストフィールドの生成
        _textField = makeTextField(CGRectMake(dx+10, 20, 300, 32),
            text: "これはテストです。")
        self.view.addSubview(_textField!)
        
        //書き込みボタンの生成
        let btnWrite = makeButton(CGRectMake(dx+55, 62, 100, 40),
            text: "書き込み", tag: BTN_WRITE)
        self.view.addSubview(btnWrite)
        
        //読み込みボタンの生成
        let btnRead = makeButton(CGRectMake(dx+165, 62, 100, 40),
            text: "読み込み", tag: BTN_READ)
        self.view.addSubview(btnRead)
    }
    
    //ボタンクリック時に呼ばれる
    func onClick(sender: UIButton) {
        if sender.tag == BTN_WRITE {
            //プリファレンスの書き込み(1)
            writePreference("text", text: _textField!.text)
        } else if sender.tag == BTN_READ {
            //プリファレンスの読み込み(2)
            _textField!.text = readPreference("text")
        }
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
    
    //アラートの表示
    func showAlert(title: NSString?, text: NSString?) {
        let alert = UIAlertController(title: title, message: text,
            preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //プリファレンスの書き込み(1)
    func writePreference(key: String, text: String) {
        let pref = NSUserDefaults.standardUserDefaults()
        pref.setObject(text, forKey: key)
        pref.synchronize()
    }
    
    //プリファレンスの読み込み(2)
    func readPreference(key: String) -> String? {
        let pref = NSUserDefaults.standardUserDefaults()
        return pref.stringForKey(key)
    }
    
//====================
//UITextFieldDelegate
//====================
    //改行ボタン押下時に呼ばれる
    func textFieldShouldReturn(sender: UITextField) -> Bool {
        //キーボードを閉じる
        self.view.endEditing(true)
        return true
    }
}
