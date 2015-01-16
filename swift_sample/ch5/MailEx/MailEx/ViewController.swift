import UIKit
import MessageUI

//メールの送信
class ViewController: UIViewController, UITextFieldDelegate,
    MFMailComposeViewControllerDelegate {
    //定数
    let BTN_SEND = 0 //送信
    
    //変数:
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
        
        //メール送信ボタンの生成
        let btnSend = makeButton(CGRectMake(dx+110, 62, 100, 40),
            text: "メール送信", tag: BTN_SEND)
        self.view.addSubview(btnSend)
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
        if sender.tag == BTN_SEND {
            let image = UIImage(named: "sample.png")
            sendMail(_textField!.text, image: image)
        }
    }
    
    //アラートの表示
    func showAlert(title: NSString?, text: NSString?) {
        let alert = UIAlertController(title: title, message: text,
            preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //メール送信
    func sendMail(text: String, image: UIImage?) {
        //メール送信可能かどうかのチェック(1)
        if !MFMailComposeViewController.canSendMail() {
            showAlert(nil, text: "メール送信できません")
            return
        }
    
        //メールビューコントローラの生成(2)
        let pickerCtl = MFMailComposeViewController()
        pickerCtl.mailComposeDelegate = self
        pickerCtl.setMessageBody(text, isHTML: false)
    
        //メールの添付ファイルの追加(3)
        if image != nil {
            let data = UIImagePNGRepresentation(image)
            pickerCtl.addAttachmentData(data,
                mimeType: "image/png", fileName: "sample.png")
        }
    
        //メールビューコントローラのビューを開く
        self.presentViewController(pickerCtl,
            animated: true, completion: nil)
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
    
//====================
//MFMailComposeViewControllerDelegate
//====================
    //メール送信完了時に呼ばれる(4)
    func mailComposeController(controller: MFMailComposeViewController!,
        didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        if error != nil {
            showAlert(nil, text: "メール送信失敗しました")
        }
            
        //オープン中のビューコントローラを閉じる
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
