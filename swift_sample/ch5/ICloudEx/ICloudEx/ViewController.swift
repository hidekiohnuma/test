import UIKit

//iCloud
class ViewController: UIViewController, UITextFieldDelegate {
    //定数
    let BTN_WRITE0 = 0 //書き込み0
    let BTN_READ0 = 1  //読み込み0
    let BTN_WRITE1 = 2 //書き込み1
    let BTN_READ1 = 3  //読み込み1
    
    //変数
    var _textField0: UITextField? //テキストフィールド0
    var _textField1: UITextField? //テキストフィールド1

//====================
//UI
//====================
    //ロード完了時に呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        let dx: CGFloat = (UIScreen.mainScreen().bounds.size.width-320)/2
        
        //キーバリューのUIの生成
        _textField0 = makeTextField(CGRectMake(dx+10, 20, 300, 32), text: "")
        self.view.addSubview(_textField0!)
        var btnWrite0 = makeButton(CGRectMake(dx+10, 70, 190, 40),
            text: "キーバリューの書き込み", tag: BTN_WRITE0)
        self.view.addSubview(btnWrite0)
        var btnRead0 = makeButton(CGRectMake(dx+210, 70, 90, 40),
            text: "読み込み", tag: BTN_READ0)
        self.view.addSubview(btnRead0)
        
        //ドキュメントのUIの生成
        _textField1 = makeTextField(CGRectMake(dx+10, 140, 300, 32), text: "")
        self.view.addSubview(_textField1!)
        var btnWrite1 = makeButton(CGRectMake(dx+10, 190, 190, 40),
            text: "ドキュメントの書き込み", tag: BTN_WRITE1)
        self.view.addSubview(btnWrite1)
        var btnRead1 = makeButton(CGRectMake(dx+210, 190, 90, 40),
            text: "読み込み", tag: BTN_READ1)
        self.view.addSubview(btnRead1)
    }
    
    //ボタンクリック時に呼ばれる
    func onClick(sender: UIButton) {
        if sender.tag == BTN_WRITE0 {
            writeICloud0()
        } else if sender.tag == BTN_READ0 {
            readICloud0()
        } else if sender.tag == BTN_WRITE1 {
            dispatch_async(dispatch_get_global_queue(
                DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                let icloudURL = self.makeICloudURL("test.txt")
                dispatch_async(dispatch_get_main_queue(), {
                    if icloudURL != nil {
                        self.writeICloud1(icloudURL!)
                    } else {
                        self.showAlert("エラー", text: "iCloudのURLの取得に失敗")
                    }
                })
            })
        } else if sender.tag == BTN_READ1 {
            dispatch_async(dispatch_get_global_queue(
                DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                let icloudURL = self.makeICloudURL("test.txt")
                dispatch_async(dispatch_get_main_queue(), {
                    if icloudURL != nil {
                        self.readICloud1(icloudURL!)
                    } else {
                        self.showAlert("エラー", text: "iCloudのURLの取得に失敗")
                    }
                })
            })
        }
    }
    
    //テキストフィールドの初期化
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
    
    //テキストボタンの初期化
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
//iCloud
//====================
    //iCloudへのキーバリューの書き込み(1)
    func writeICloud0() {
        var store = NSUbiquitousKeyValueStore.defaultStore()
        store.setObject(_textField0!.text, forKey: "text")
        store.synchronize()
    }
    
    //iCloudからのキーバリューの読み込み(2)
    func readICloud0() {
        var store = NSUbiquitousKeyValueStore.defaultStore()
        _textField0!.text = store.stringForKey("text")
    }
    
    //iCloudのドキュメントのURLの生成(3)
    func makeICloudURL(fileName: NSString) -> NSURL? {
        //iCloudのディレクトリのURLの生成
        let fileManager = NSFileManager.defaultManager()
        var icloudURL = fileManager.URLForUbiquityContainerIdentifier(nil)
        if let docURL = icloudURL?.URLByAppendingPathComponent("Documents") {
            //ディレクトリがない時は生成
            if fileManager.fileExistsAtPath(docURL.path!) == false {
                fileManager.createDirectoryAtURL(docURL,
                    withIntermediateDirectories: true,
                    attributes: nil, error: nil)
            }
    
            //iCloudのドキュメントのURLを返す
            return docURL.URLByAppendingPathComponent(fileName)
        }
        return nil;
    }
    
    //iCloudへのドキュメントの書き込み(4)
    func writeICloud1(icloudURL: NSURL) {
        var document = ICloudDocument(fileURL: icloudURL)
        document.text = _textField1!.text
        document.saveToURL(icloudURL,
            forSaveOperation: UIDocumentSaveOperation.ForCreating,
            completionHandler: {(success: Bool) in
                 println("write document>\(success)")
        })
    }
    
    //iCloudからのドキュメントの読み込み(5)
    func readICloud1(icloudURL: NSURL) {
        var document = ICloudDocument(fileURL: icloudURL)
        document.openWithCompletionHandler({(success: Bool) in
            println("read document>\(success)")
            self._textField1!.text = document.text
        })
    }
    
//====================
//UITextFieldDelegate
//====================
    //改行ボタン押下時に呼ばれる
    func textFieldShouldReturn(sender: UITextField!) -> Bool {
        //キーボードを閉じる
        self.view.endEditing(true)
        return true
    }
}
