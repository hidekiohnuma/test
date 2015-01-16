import UIKit
import NotificationCenter

//Todayビューコントローラ
class TodayViewController: UIViewController {
    @IBOutlet var _label: UILabel? //ラベル(2)
    
    //ロード完了時に呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //共有領域の変更時に通知(3)
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "userDefaultsDidChange:",
            name: NSUserDefaultsDidChangeNotification, object: nil)
        
        //ウィジェットの推奨サイズの指定(5)
        self.preferredContentSize = CGSizeMake(320, 37)
        
        //テキスト表示
        updateTextLabel()
    }
    
    //共有領域の変更時に呼ばれる(4)
    func userDefaultsDidChange(notification: NSNotification) {
        updateTextLabel()
    }
    
    //テキストラベルの更新
    func updateTextLabel() {
        //App Groupの共有領域からの読み込み(6)
        let defaults:NSUserDefaults = NSUserDefaults(suiteName: "group.TodayEx")!
        _label!.text = defaults.stringForKey("text")
    }
    
    //ウィジェットの画面更新時に呼ばれる(7)
    func widgetPerformUpdateWithCompletionHandler(
        completionHandler: ((NCUpdateResult) -> Void)!) {
        completionHandler(NCUpdateResult.NewData)
    }    
}
