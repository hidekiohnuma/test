import UIKit

//Today
class ViewController: UIViewController, UITextFieldDelegate {
    //定数
    let BTN_WRITE = 0 //書き込み
    
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
        _textField = makeTextField(CGRectMake(dx+10, 20, 300, 30), text: "")
        _textField!.text = "これはテストです。"
        self.view.addSubview(_textField!)
        
        //書き込みボタンの生成
        let btnWrite = makeButton(CGRectMake(dx+60, 60, 200, 40),
            text: "書き込み", tag: BTN_WRITE)
        self.view.addSubview(btnWrite)
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
        if sender.tag == BTN_WRITE {
            //App Groupの共有領域に書き込み(1)
            let userDefaults = NSUserDefaults(suiteName: "group.TodayEx")!
            userDefaults.setObject(_textField!.text, forKey: "text")
            userDefaults.synchronize()
        }
    }
    
//====================
//UITextFieldDelegate
//====================
    //改行ボタン押下時に呼ばれる
    func textFieldShouldReturn(sender: UITextField!) -> Bool {
        //キーボードを隠す
        self.view.endEditing(true)
        return true
    }
}
