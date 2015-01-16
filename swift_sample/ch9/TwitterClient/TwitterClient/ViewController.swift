import UIKit
import Social
import Accounts

//Twitterクライアント
class ViewController: UIViewController,
    UITableViewDelegate, UITableViewDataSource {
    //画面サイズ定数
    let SCREEN = UIScreen.mainScreen().bounds.size //画面サイズ
    
    //変数
    @IBOutlet var _tableView: UITableView? //テーブルビュー
    var _accountStore: ACAccountStore?     //アカウントストア
    var _account: ACAccount?               //アカウント
    var _items = [Status]()                //要素群

//====================
//UI
//====================
    //ロード完了時に呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UI
        self.title = "Twitterクライアント"
        
        //Twitterアカウントの取得(1)
        initTwitterAccount()
    }
    
    //ツールバーボタンクリック時に呼ばれる
    @IBAction func onClick(sender: UIBarButtonItem) {
        if _account == nil {
            initTwitterAccount()
            return
        }
        if sender.tag == 0 {
            timeline()
        } else if sender.tag == 1 {
            twit()
        }
    }
    
    //ラベルの生成
    func makeLabel(frame: CGRect, text: NSString, font: UIFont) -> UILabel {
        let label = UILabel()
        label.frame = frame
        label.text = text
        label.font = font
        label.textColor = UIColor.blackColor()
        label.backgroundColor = UIColor.clearColor()
        label.textAlignment = NSTextAlignment.Left
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.numberOfLines = 0
        return label
    }
    
    //イメージビューの生成
    func makeImageView(frame: CGRect, image: UIImage?) -> UIImageView {
        let imageView = UIImageView()
        imageView.frame = frame
        imageView.image = image
        return imageView
    }
    
    //アラートの表示
    func showAlert(title: NSString?, text: NSString?) {
        let alert = UIAlertController(title: title, message: text, //(5)
            preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", //(6)
            style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)//(7)
    }
    
    //インジケーターの指定
    func setIndicator(indicator: Bool) {
        UIApplication.sharedApplication(
            ).networkActivityIndicatorVisible = indicator
    }
    
//====================
//UITableViewDelegate
//====================
    //セルの高さの取得
    func tableView(tableView: UITableView!,
        heightForRowAtIndexPath indexPath:  NSIndexPath!) -> CGFloat {
        let status = _items[indexPath.row]
        let label = makeLabel(CGRectMake(60, 30, SCREEN.width-70, 1024),
            text: status.text, font: UIFont.systemFontOfSize(14))
        label.sizeToFit()
        let height = 30+label.frame.size.height+10
        return height < 60 ? 60 : height
    }
    
//====================
//UITableViewDataSource
//====================
    //セルの数取得時に呼ばれる
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        return _items.count
    }
    
    
    //セルの取得時に呼ばれる(7)
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //テーブルのセルの生成
        var cell: UITableViewCell? = tableView
            .dequeueReusableCellWithIdentifier("table_cell") as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default,
                reuseIdentifier: "table_cell")
            
            //アイコンの追加
            let imgIcon = makeImageView(CGRectMake(10, 10, 40, 40), image: nil)
            imgIcon.tag = 1
            cell!.contentView.addSubview(imgIcon)
            
            //名前の追加
            let lblName = makeLabel(CGRectMake(60, 10, 250, 16), text: "",
                font: UIFont.boldSystemFontOfSize(16))
            lblName.tag = 2
            cell!.contentView.addSubview(lblName)
            
            //テキストの追加
            let lblText = makeLabel(CGRectMake(60, 30, 320, 1024),
                text: "", font: UIFont.systemFontOfSize(14))
            lblText.tag = 3
            cell!.contentView.addSubview(lblText)
        }
        if _items.count <= indexPath.row {return cell!}
            
        //ステータスの取得
        let status = _items[indexPath.row]
            
        //アイコンの指定
        let imgIcon = cell!.contentView.viewWithTag(1) as UIImageView
        imgIcon.image = status.icon
            
        //名前の指定
        let lblName = cell!.contentView.viewWithTag(2) as UILabel
        lblName.text = status.name
            
            
        //テキストの追加
        let lblText = cell!.contentView.viewWithTag(3) as UILabel
        lblText.text = status.text
        lblText.frame = CGRectMake(60, 30, SCREEN.width-70, 1024)
        lblText.sizeToFit()
        return cell!
    }
    
//====================
//Twitter
//====================
    //Twitterのアカウント情報の取得(1)
    func initTwitterAccount() {
        _account = nil
        _accountStore = ACAccountStore()
        let twitterType = _accountStore?
            .accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        _accountStore?.requestAccessToAccountsWithType(
            twitterType, options:nil) {(granted, error) in
            if granted {
                let accounts = self._accountStore?
                    .accountsWithAccountType(twitterType)
                if accounts!.count > 0 {
                    self._account = accounts![0] as? ACAccount
                    self.timeline()
                    return
                }
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.showAlert(nil, text:"Twitterアカウントが登録されていません")
            })
        }
    }
    
    //アイコンの読み込み
    func loadIcon(status: Status) {
        //通信によるアイコン読み込み
        dispatch_async(dispatch_get_global_queue(
            DISPATCH_QUEUE_PRIORITY_DEFAULT,0)) {
            let request = NSURLRequest(URL: NSURL(string: status.iconURL)!,
                cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy,
                timeoutInterval: 30.0)
            let data = NSURLConnection.sendSynchronousRequest(request,
                returningResponse:nil, error:nil)

            //テーブル更新
            dispatch_async(dispatch_get_main_queue()) {
                status.icon = UIImage(data: data!)
                self._tableView?.reloadData()
            }
        }
    }

    //タイムラインの取得
    func timeline() {
        //インジケータ表示
        self.setIndicator(true)
    
        //タイムラインの読み込み(2)
        let url = NSURL(string:
            "https://api.twitter.com/1.1/statuses/home_timeline.json")!
        let params: Dictionary<NSObject, AnyObject!> = ["count": "20"]
        let timeline = SLRequest(forServiceType: SLServiceTypeTwitter,
            requestMethod: SLRequestMethod.GET, URL: url, parameters: params)
        timeline.account = self._account
        timeline.performRequestWithHandler(){(responseData: NSData!,
            urlResponse: NSHTTPURLResponse!, error: NSError!) in
            //JSONのパース(3)
            var jsonError: NSError? = nil
            let obj : AnyObject? = NSJSONSerialization.JSONObjectWithData(
                responseData, options: nil, error: &jsonError)
            
            //エラー表示
            if error != nil {
                self.showAlert(nil, text: "通信失敗しました")
            } else if obj == nil || jsonError != nil {
                self.showAlert(nil, text: "パースに失敗しました")
            } else if !obj!.isKindOfClass(NSArray) {
                self.showAlert(nil, text: "パースに失敗しました")
            } else {
                //JSONをパースしたデータをStatusクラスの配列に変換(4)
                self._items.removeAll()
                let statuses = obj as NSArray
                for var i = 0; i < statuses.count; i++ {
                    let item = Status()
                    let status = statuses[i] as NSDictionary
                    let user  = status["user"] as NSDictionary
                    item.text = status["text"] as String
                    item.name  = user["screen_name"] as String
                    item.iconURL = user["profile_image_url"] as String
                    self.loadIcon(item)
                    self._items.append(item)
                }
            }

            //テーブル更新
            dispatch_async(dispatch_get_main_queue(), {
                let tableView = self._tableView
                tableView?.reloadData()
            })
            
            //インジケータ非表示
            self.setIndicator(false)
        }
    }
    
    //つぶやきの送信(5)
    func twit() {
        let twitterCtl = SLComposeViewController(
            forServiceType: SLServiceTypeTwitter)
        self.presentViewController(twitterCtl, animated: true, completion: nil)
    }
    
//====================
//ユーティリティ
//====================
    //バイト配列を文字列に変換
    func data2str(data: NSData) -> NSString {
        return NSString(data: data, encoding: NSUTF8StringEncoding)!
    }
}
