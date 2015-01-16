import UIKit

//ファイルの読み書き
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
        button.addTarget(self, action:  "onClick:",
            forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }
    
    //ボタンクリック時に呼ばれる
    func onClick(sender: UIButton) {
        if sender.tag == BTN_WRITE {
            if let data = str2data(_textField!.text) {
                data2file(data, fileName: "test.txt")
            }
        } else if sender.tag == BTN_READ {
            if let data = file2data("test.txt") {
                _textField!.text = data2str(data)
            } else {
                _textField!.text = ""
            }
        }
    }
    
//====================
//ファイルの読み書き
//====================
    //文字列をバイト配列に変換(1)
    func str2data(str: NSString) -> NSData? {
        return str.dataUsingEncoding(NSUTF8StringEncoding)
    }
    
    //バイト配列を文字列に変換(2)
    func data2str(data: NSData) -> NSString {
        return NSString(data: data, encoding: NSUTF8StringEncoding)!
    }
    
    //バイト配列の書き込み(3)
    func data2file(data: NSData, fileName: NSString) -> Bool {
        var path = NSHomeDirectory().stringByAppendingPathComponent("Documents")
        path = path.stringByAppendingPathComponent(fileName)
        return data.writeToFile(path, atomically: true)
    }
    
    //バイト配列の読み込み(4)
    func file2data(fileName: NSString) -> NSData? {
        var path = NSHomeDirectory().stringByAppendingPathComponent("Documents")
        path = path.stringByAppendingPathComponent(fileName)
        return NSData(contentsOfFile: path,
            options: NSDataReadingOptions.DataReadingMappedIfSafe, error: nil)
    }
    
//====================
//UITextFieldDelegate
//====================
    //改行ボタン押下時に呼ばれる
    func textFieldShouldReturn(sender: UITextField) -> Bool {
        //キーボードを隠す
        self.view.endEditing(true)
        return true
    }
}
