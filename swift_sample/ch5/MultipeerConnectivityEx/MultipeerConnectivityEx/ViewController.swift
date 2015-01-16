import UIKit
import GameKit
import MultipeerConnectivity

//Multipeer Connectivity
class ViewController: UIViewController, UITextFieldDelegate,
    MCSessionDelegate, MCBrowserViewControllerDelegate {
    //定数
    let BTN_ADVERTIZE = 0          //アドバタイズ
    let BTN_BROWSE = 1             //ブラウザ
    let BTN_SEND = 2               //送信
    let BTN_DISCONNECT = 3         //切断
    let SERVICE_TYPE = "MyService" //サービス種別
    
    //変数
    //UI
    var _textField: UITextField?  //テキストフィールド
    var _btnAdvertise: UIButton?  //アドバタイズボタン
    var _btnBrowse: UIButton?     //ブラウザボタン
    var _btnSend: UIButton?       //送信ボタン
    var _btnDisconnect: UIButton? //切断ボタン
    
    //Multipeer Connectivity
    var _state: MCSessionState?                         //状態
    var _myPeerID: MCPeerID?                            //ピアID
    var _session: MCSession?                            //セッション
    var _assistant: MCAdvertiserAssistant?              //アドバタイザアシスタント
    var _browseViewController: MCBrowserViewController? //ブラウズビューコントローラ
    
    
//====================
//UI
//====================
    //ロード完了時に呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        let dx: CGFloat = (UIScreen.mainScreen().bounds.size.width-320)/2
        
        //ピアIDの生成(1)
        _myPeerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        
        //セッションの生成(2)
        _session = MCSession(peer: _myPeerID, securityIdentity:nil,
            encryptionPreference:MCEncryptionPreference.Required)
        _session!.delegate = self
        
        //アドバイザアシスタントの生成(3)
        _assistant = MCAdvertiserAssistant(serviceType: SERVICE_TYPE,
            discoveryInfo: nil, session: _session)
        
        //テキストフィールドの生成
        _textField = makeTextField(CGRectMake(dx+10, 20, 300, 32), text: "")
        self.view.addSubview(_textField!)
        
        //アドバタイズボタンの生成
        _btnAdvertise = makeButton(CGRectMake(dx+60, 70, 90, 40),
            text: "アドバタイズ", tag: BTN_ADVERTIZE)
        self.view.addSubview(_btnAdvertise!)
        
        //ブラウズボタンの生成
        _btnBrowse = makeButton(CGRectMake(dx+160, 70, 90, 40),
            text: "ブラウズ", tag: BTN_BROWSE)
        self.view.addSubview(_btnBrowse!)
        
        //送信ボタンの生成
        _btnSend = makeButton(CGRectMake(dx+60, 70, 90, 40),
            text: "送信", tag: BTN_SEND)
        self.view.addSubview(_btnSend!)
        
        //切断ボタンの生成
        _btnDisconnect = makeButton(CGRectMake(dx+160, 70, 90, 40),
            text: "切断", tag: BTN_DISCONNECT)
        self.view.addSubview(_btnDisconnect!)
        
        //ボタンの更新
        _state = MCSessionState.NotConnected
        updateButton()
    }
    
    //ボタンクリック時に呼ばれる
    func onClick(sender: UIButton) {
        //アドバタイズの開始(3)
        if sender.tag == BTN_ADVERTIZE {
            _assistant?.start()
            showAlert(nil, text: "アドバタイズ開始しました")
        }
        //ブラウズの開始(5)
        else if sender.tag == BTN_BROWSE {
            _browseViewController = MCBrowserViewController(
                serviceType: SERVICE_TYPE, session: _session)
            _browseViewController!.delegate = self
            _browseViewController!.minimumNumberOfPeers = 1
            _browseViewController!.maximumNumberOfPeers = 1
            self.presentViewController(_browseViewController!,
                animated: true, completion: nil)
        }
        //メッセージの送信(7)
        else if sender.tag == BTN_SEND {
            var data = str2data(_textField!.text)
            var peerIDs = _session?.connectedPeers
            var error:NSError? = nil
            _session?.sendData(data, toPeers: peerIDs,
                withMode: MCSessionSendDataMode.Reliable, error: &error)
        }
        //セッションの切断
        else if sender.tag == BTN_DISCONNECT {
            _session?.disconnect()
            _state = MCSessionState.NotConnected
            updateButton()
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
    
    //アラートの表示
    func showAlert(title: NSString?, text: NSString?) {
        let alert = UIAlertController(title: title, message: text,
            preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil) 
    }
    
//====================
//MultipeerConnectivity
//====================
    //ボタンの指定
    func updateButton() {
        //セッション未接続
        if _state == MCSessionState.NotConnected {
            _btnAdvertise!.alpha = 1.0
            _btnBrowse!.alpha = 1.0
            _btnSend!.alpha = 0.0
            _btnDisconnect!.alpha = 0.0
        }
        //セッション接続中
        else if _state == MCSessionState.Connecting {
            _btnAdvertise!.alpha = 0.0
            _btnBrowse!.alpha = 0.0
            _btnSend!.alpha = 0.0
            _btnDisconnect!.alpha = 0.0
        }
        //セッション接続
        else if _state == MCSessionState.Connected {
            _btnAdvertise!.alpha = 0.0
            _btnBrowse!.alpha = 0.0
            _btnSend!.alpha = 1.0
            _btnDisconnect!.alpha = 1.0
        }
    }
    
    //テキストフィールドの更新
    func updateTextField(text: String) {
        _textField!.text = text
    }
    
    //文字列をバイト配列に変換
    func str2data(str: NSString) -> NSData? {
        return str.dataUsingEncoding(NSUTF8StringEncoding)
    }
    
    //バイト配列を文字列に変換
    func data2str(data: NSData) -> NSString {
        return NSString(data: data, encoding: NSUTF8StringEncoding)!
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
//MCSessionDelegate
//====================
    //NSDataオブジェクト受信時に呼ばれる(3)
    func session(session: MCSession!, didReceiveData data: NSData!,
        fromPeer peerID: MCPeerID!) {
        dispatch_async(dispatch_get_main_queue(), {//(9)
            //テキストフィールドの更新(8)
            self.updateTextField(self.data2str(data))
        })
    }
    
    //ファイルリソースの受信開始時に呼ばれる(3)
    func session(session: MCSession!, didStartReceivingResourceWithName
        resourceName: String!, fromPeer peerID: MCPeerID!,
        withProgress progress: NSProgress!) {
    }
    
    //ファイルリソースの受信終了時に呼ばれる(3)
    func session(session: MCSession!, didFinishReceivingResourceWithName
        resourceName: String!, fromPeer peerID: MCPeerID!,
        atURL localURL: NSURL!, withError error: NSError!) {
    }
    
    //バイトストリームの接続開始時に呼ばれる(3)
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!,
        withName streamName: String!, fromPeer peerID: MCPeerID!) {
    }
    
    //状態変更時に呼ばれる(3)
    func session(session: MCSession!, peer peerID: MCPeerID!,
        didChangeState state: MCSessionState) {
        dispatch_async(dispatch_get_main_queue(), {//(9)
            //ボタンの更新
            self._state = state
            self.updateButton()
        })
    }
    
//====================
//MCBrowserViewControllerDelegate
//====================
    //ブラウズ終了時に呼ばれる(6)
    func browserViewControllerDidFinish(browserViewController:
        MCBrowserViewController!) {
        _browseViewController?.dismissViewControllerAnimated(
            true, completion: nil)
    }
    
    //ブラウズキャンセル時に呼ばれる(6)
    func browserViewControllerWasCancelled(browserViewController:
        MCBrowserViewController!) {
        _browseViewController?.dismissViewControllerAnimated(
            true, completion: nil)
    }
}
