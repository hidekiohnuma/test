import UIKit

//ナビゲーションとテーブルビュー
class ViewController: UIViewController,
    UITableViewDelegate, UITableViewDataSource {
    var _tableView: UITableView?         //テーブルビュー
    var _folderName: String?             //フォルダ名
    var _folders = [String: [String]]() //フォルダ郡
    
//====================
//UI
//====================
    //ロード完了時に呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ファイルとフォルダ階層の定義(2)
        _folders = makeFolders()
        
        //ナビゲーションバーのボタンの追加(3)
        var button = UIBarButtonItem(title: "ボタン",
            style: UIBarButtonItemStyle.Bordered,
            target: self, action: "onClick:")
        self.navigationItem.rightBarButtonItem = button
        
        //テーブルビューの生成(4)
        _tableView = makeTableView(self.view.frame)
        self.view.addSubview(_tableView!)
    }
    
    //ファイルとフォルダ階層の定義(2)
    func makeFolders() -> [String: [String]] {
        var folders = [String: [String]]()
        folders["ホーム"] = ["フォルダ1", "フォルダ2", "フォルダ3"]
        folders["フォルダ1"] = ["ファイル1-1", "ファイル1-2", "ファイル1-3"]
        folders["フォルダ2"] = ["ファイル2-1", "ファイル2-2"]
        folders["フォルダ3"] = ["ファイル3-1", "ファイル3-2", "フォルダ3-3"]
        folders["フォルダ3-3"] = ["ファイル3-3-1", "ファイル3-3-2"]
        return folders
    }
    
    //フォルダ名の指定
    func setFolderName(folderName: String) {
        _folderName = folderName
        
        //ナビゲーションバーのタイトルの指定(5)
        self.title = folderName
    }
    
    //ボタンクリック時に呼ばれる
    func onClick(sender: UIButton) {
        showAlert("", text: "バーボタンを押した")
    }
    
    //アラートの表示
    func showAlert(title: NSString?, text: NSString?) {
        let alert = UIAlertController(title: title, message: text,
            preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //テーブルビューの生成(4)
    func makeTableView(frame: CGRect) -> UITableView {
        let tableView = UITableView()
        tableView.frame = frame
        tableView.autoresizingMask =
            UIViewAutoresizing.FlexibleRightMargin |
            UIViewAutoresizing.FlexibleTopMargin |
            UIViewAutoresizing.FlexibleLeftMargin |
            UIViewAutoresizing.FlexibleBottomMargin |
            UIViewAutoresizing.FlexibleWidth |
            UIViewAutoresizing.FlexibleHeight
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }
    
//====================
//UITableViewDelegate
//====================
    //セルの高さの取得(6)
    func tableView(tableView: UITableView,
        heightForRowAtIndexPath indexPath:  NSIndexPath) -> CGFloat {
        return 50
    }
    
    //セルのクリック時に呼ばれる(6)
    func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath) {
            //ファイルの取得
            let files = _folders[_folderName!]
            let file = files![indexPath.row]
            
            //フォルダ
            if file.hasPrefix("フォルダ") {
                //ナビゲーションの遷移(11)
                let viewCtl = ViewController()
                viewCtl.setFolderName(file)
                self.navigationController?.pushViewController(
                    viewCtl, animated: true)
            }
            //ファイル
            else if file.hasPrefix("ファイル") {
                showAlert(nil, text: file)
            }
            
            //テーブルのセルの選択解除(10)
            tableView.deselectRowAtIndexPath(
                tableView.indexPathForSelectedRow()!, animated: true)
    }
    
//====================
//UITableViewDataSource
//====================
    //セルの数取得時に呼ばれる(7)
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        let files = _folders[_folderName!]
        return files!.count
    }
    
    //セルの取得時に呼ばれる(7)
    func tableView(tableView: UITableView, cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
        //テーブルのセルの生成(8)
        var cell = tableView.dequeueReusableCellWithIdentifier(
            "table_cell") as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default,
                reuseIdentifier: "table_cell")
        }
            
        //テーブルのセルの設定(9)
        var files = _folders[_folderName!]
        cell!.textLabel.text = files![indexPath.row]
        if cell!.textLabel.text!.hasPrefix("フォルダ") {
            cell!.accessoryType =
                UITableViewCellAccessoryType.DisclosureIndicator
        }
        return cell!
    }
}
