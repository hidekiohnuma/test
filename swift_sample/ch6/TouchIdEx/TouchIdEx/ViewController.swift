import UIKit
import LocalAuthentication

//TouchID
class ViewController: UIViewController {
    let BTN_TOUCH_ID = 0 //TouchID
    
//====================
//UI
//====================
    //ロード完了時に呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        let dx: CGFloat = (UIScreen.mainScreen().bounds.size.width-320)/2
        
        //TouchIDボタンの生成
        let btnAlert = makeButton(CGRectMake(dx+60, 20, 200, 40),
            text: "TouchID", tag: BTN_TOUCH_ID)
        self.view.addSubview(btnAlert)
    }
    
    //ボタンクリック時に呼ばれる
    func onClick(sender: UIButton!) {
        if sender.tag == BTN_TOUCH_ID {
            startAuth()
        }
    }
    
    //ボタンの生成
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
    
//====================
//認証
//====================
    //認証
    func startAuth() {
        //認証コンテキストの生成(1)
        var laContext = LAContext();
        var error: NSError? = nil;
        
        //TouchID認証が利用可能かどうか(1)
        if !laContext.canEvaluatePolicy(
            LAPolicy.DeviceOwnerAuthenticationWithBiometrics,
            error: &error) {
            showAlert(nil, text: "TouchID認証が利用できない端末です")
            return;
        }
        
        //TouchID認証の開始(2)
        laContext.evaluatePolicy(
            LAPolicy.DeviceOwnerAuthenticationWithBiometrics,
            localizedReason:"TouchIdExで認証します",
            reply:{(success: Bool, error: NSError!) in
                dispatch_async(dispatch_get_main_queue(), {
                    if success {
                        self.showAlert(nil, text: "認証に成功しました")
                    } else {
                        self.showAlert(nil, text: "認証に失敗しました")
                    }
                })
            })
    }
}
