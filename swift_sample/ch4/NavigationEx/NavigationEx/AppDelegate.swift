import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {    
    var window: UIWindow? //ウィンドウ
    
    //アプリ起動完了時に呼ばれる
    func application(application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [NSObject : AnyObject]?) -> Bool {
        //ナビゲーションコントローラの取得(1)
        let navCtl = self.window!.rootViewController as UINavigationController
            
        //ビューコントローラの生成
        let viewCtl = ViewController()
        viewCtl.setFolderName("ホーム")
        navCtl.pushViewController(viewCtl, animated: false) //(1)
        return true
    }
}

