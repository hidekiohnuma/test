import UIKit
import AddressBook

//アドレス帳
class ViewController: UIViewController,
    UITableViewDelegate, UITableViewDataSource {
    var _tableView: UITableView? //テーブルビュー
    var _names = [String]()      //名前
    var _tels = [String]()       //電話番号
    
//====================
//UI
//====================
    //ロード完了時に呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //テーブルビューの生成
        _tableView = makeTableView(
            CGRectMake(0, 20, self.view.frame.width, self.view.frame.height-20))
        self.view.addSubview(_tableView!)
        
        //アドレスの読み込み
        readAddress()
    }
    
    //テーブルビューの生成
    func makeTableView(frame: CGRect) -> UITableView {
        var tableView = UITableView()
        tableView.frame = frame;
        tableView.autoresizingMask =
            UIViewAutoresizing.FlexibleRightMargin |
            UIViewAutoresizing.FlexibleTopMargin |
            UIViewAutoresizing.FlexibleLeftMargin |
            UIViewAutoresizing.FlexibleBottomMargin |
            UIViewAutoresizing.FlexibleWidth |
            UIViewAutoresizing.FlexibleHeight
        tableView.delegate = self
        tableView.dataSource = self
        return tableView;
    }
    
    //アラートの表示(
    func showAlert(title: NSString?, text: NSString?) {
        let alert = UIAlertController(title: title, message: text,
            preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //URLスキームのオープン(1)
    func openURL(urlPath: String) -> Bool {
        var url = NSURL(string: urlPath)!
        return UIApplication.sharedApplication().openURL(url)
    }
    
//====================
//アドレスの読み込み
//====================
    //アドレスの読み込み
    func readAddress() {
        _names.removeAll()
        _tels.removeAll()
        
        //ABAddressBookオブジェクトの取得(2)
        var book: ABAddressBook =
            ABAddressBookCreateWithOptions(nil, nil).takeUnretainedValue()
    
        //アクセス許可状態の確認(3)
        let status = ABAddressBookGetAuthorizationStatus()
        //アクセス許可を求めたことがない
        if status == ABAuthorizationStatus.NotDetermined {
            ABAddressBookRequestAccessWithCompletion(book, {
                (granted: Bool, error: CFError!) in
                if granted {
                    NSOperationQueue.mainQueue().addOperationWithBlock {
                        self.readAddress()
                    }
                } else {
                    self.showAlert(nil, text: 
                      "「設定→プライバシー→連絡先→AddressEx」をオンにしてください")
                }
            })
            return
        }
        //アクセス許可されていない
        else if status != ABAuthorizationStatus.Authorized {
            showAlert(nil, text:
                "「設定→プライバシー→連絡帳→AddressEx」をオンにしてください")
            return
        }
    
        //アドレスのレコードの取得(4)
        let records: NSArray =
            ABAddressBookCopyArrayOfAllPeople(book).takeUnretainedValue()
        for record in records {
            if ABRecordCopyValue(record, kABPersonFirstNameProperty) == nil ||
                ABRecordCopyValue(record, kABPersonLastNameProperty) == nil {
                continue
            }
            
            //レコードからの名前の取得(5)
            var firstName =
                ABRecordCopyValue(record, kABPersonFirstNameProperty) == nil ? "" :
                ABRecordCopyValue(record, kABPersonFirstNameProperty)
                    .takeUnretainedValue() as String
            var lastName =
                ABRecordCopyValue(record, kABPersonLastNameProperty) == nil ? "" :
                ABRecordCopyValue(record, kABPersonLastNameProperty)
                    .takeUnretainedValue() as String
            _names.append("\(lastName) \(firstName)")
    
            //レコードからの電話番号の取得(6)
            var tels: ABMultiValue =
                ABRecordCopyValue(record, kABPersonPhoneProperty)
                    .takeUnretainedValue()
            var tel = ""
            if ABMultiValueGetCount(tels) > 0 {
                tel = ABMultiValueCopyValueAtIndex(tels, 0)
                    .takeUnretainedValue() as String
            }
            _tels.append(tel)
        }
    
        //テーブルビューの更新(7)
        _tableView!.reloadData()
    }
    
//====================
//UITableViewDelegate
//====================
    //セルの高さの取得
    func tableView(tableView: UITableView,
        heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    //セルのクリック時に呼ばれる
    func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //選択解除
        tableView.deselectRowAtIndexPath(
            tableView.indexPathForSelectedRow()!, animated: true)
            
        //通話
        let tel = _tels[indexPath.row]
        if countElements(tel) > 0 {
            if !openURL("tel:\(tel)") {
                showAlert(nil, text: "通話機能がありません")
            }
        }
    }
    
    //セルの取得時に呼ばれる
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath:  NSIndexPath) -> UITableViewCell {
        //テーブルのセルの生成
        var cell = tableView.dequeueReusableCellWithIdentifier("table_cell")
            as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle,
                reuseIdentifier: "table_cell")
        }
        cell!.textLabel.text = _names[indexPath.row]
        cell!.detailTextLabel?.text = _tels[indexPath.row]
        return cell!
    }
    
//====================
//UITableViewDataSource
//====================
    //セルの数取得時に呼ばれる
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        return _names.count
    }
}
