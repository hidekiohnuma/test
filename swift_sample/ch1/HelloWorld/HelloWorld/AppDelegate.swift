import UIKit //(1)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate { //(2)
    var window: UIWindow? //ウィンドウ

    //アプリ起動完了時に呼ばれる
    func application(application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [NSObject : AnyObject]?) -> Bool {
        return true
    }
}

