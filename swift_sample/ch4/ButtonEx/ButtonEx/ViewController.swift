import UIKit

//ボタンとアラート
class ViewController: UIViewController {
    //定数(2)
    let BTN_ALERT = 0 //アラート表示
    let BTN_YESNO = 1 //Yes/Noダイアログ表示
    let BTN_SHEET = 2 //アクションシート表示
    let BTN_IMAGE = 3 //イメージボタン
    
    //ロード完了時に呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        let dx: CGFloat = (UIScreen.mainScreen().bounds.size.width-320)/2
        
        //アラート表示ボタンの生成(1)
        let btnAlert = makeButton(CGRectMake(dx+60, 20, 200, 40),
            text: "アラート表示", tag: BTN_ALERT)
        self.view.addSubview(btnAlert)
        
        //YES/NOダイアログの生成
        let btnYesNo = makeButton(CGRectMake(dx+60, 70, 200, 40),
            text: "Yes/Noダイアログ表示", tag: BTN_YESNO)
        self.view.addSubview(btnYesNo)
        
        //アクションシート表示ボタンの生成
        let btnSheet = makeButton(CGRectMake(dx+60, 120, 200, 40),
            text: "アクションシート表示", tag: BTN_SHEET)
        self.view.addSubview(btnSheet)
        
        //イメージボタンの生成(4)
        let btnImage = makeButton(CGRectMake(dx+103, 170, 114, 114),
            image: UIImage(named: "sample.png")!, tag: BTN_IMAGE)
        self.view.addSubview(btnImage)
    }
    
    //ボタンクリック時に呼ばれる(3)
    func onClick(sender: UIButton) {
        if sender.tag == BTN_ALERT {
            //アラートの表示
            showAlert("", text: "アラート表示ボタンを押した")
        } else if sender.tag == BTN_YESNO {
            //Yes/Noダイアログの表示
            showYesNoDialog("", text: "Yes/Noダイアログ表示ボタンを押した")
        } else if sender.tag == BTN_SHEET {
            //アクションシートの表示
            showActionSheet("アクションシートの表示", text :nil)
        } else if sender.tag == BTN_IMAGE {
            //アラートの表示
            showAlert(nil, text: "イメージボタンを押した")
        }
    }
    
    //ボタンの生成(1)
    func makeButton(frame: CGRect, text: NSString, tag: Int) -> UIButton {
        let button = UIButton.buttonWithType(UIButtonType.System) as UIButton
        button.frame = frame                                   //領域
        button.setTitle(text, forState: UIControlState.Normal)//タイトル
        button.tag = tag                                      //タグ(2)
        button.addTarget(self, action: "onClick:",            //ターゲット(3)
            forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }
    
    //イメージボタンの生成(4)
    func makeButton(frame: CGRect, image: UIImage, tag: Int) -> UIButton {
        let button = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        button.frame = frame                                   //領域
        button.setImage(image, forState: UIControlState.Normal)//イメージ
        button.tag = tag                                       //タグ
        button.addTarget(self, action: "onClick:",             //ターゲット
            forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }
    
    //アラートの表示
    func showAlert(title: NSString?, text: NSString?) {
        let alert = UIAlertController(title: title, message: text, //(5)
            preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", //(6)
            style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)//(7)
    }
    
    //Yes/Noダイアログの表示(8)
    func showYesNoDialog(title: NSString?, text: NSString?) {
        let alert = UIAlertController(title: title, message: text,
            preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Yes",
            style: UIAlertActionStyle.Default, handler: {(alert) in
                self.showAlert(nil, text: "Yesをクリック")
            }))
        alert.addAction(UIAlertAction(title: "No",
            style: UIAlertActionStyle.Default, handler: {(alert) in
                self.showAlert(nil, text: "Noをクリック")
            }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //アクションシートの表示(9)
    func showActionSheet(title: NSString?, text: NSString?) {
        let alert = UIAlertController(title: title, message: text,
            preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.addAction(UIAlertAction(title: "項目0",
            style: UIAlertActionStyle.Default, handler: {(alert) in
                self.showAlert(nil, text: "項目0をクリック")
            }))
        alert.addAction(UIAlertAction(title: "項目1",
            style: UIAlertActionStyle.Default, handler: {(alert) in
                self.showAlert(nil, text: "項目1をクリック")
            }))
        alert.addAction(UIAlertAction(title: "項目2",
            style: UIAlertActionStyle.Default, handler: {(alert) in
                self.showAlert(nil, text: "項目2をクリック")
            }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
