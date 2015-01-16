import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow? //ウィンドウ
    var _bgTask: UIBackgroundTaskIdentifier? //バックグラウンドタスクのID(1)
    
    //アプリ起動完了時に呼ばれる
    func application(application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [NSObject : AnyObject]?) -> Bool {
        //ローカルノティフィケーションの利用許可の取得(4)
        application.registerUserNotificationSettings(UIUserNotificationSettings(
            forTypes: UIUserNotificationType.Sound | UIUserNotificationType.Alert,
            categories: nil))
        return true
    }
    
    //アプリ一時停止時に呼ばれる
    func applicationWillResignActive(application: UIApplication) {
        println("applicationWillResignActive")
    }
    
    //バックグラウンド遷移時に呼ばれる
    func applicationDidEnterBackground(application: UIApplication) {
        println("applicationDidEnterBackground")
        let app = UIApplication.sharedApplication()
        
        //バックグラウンドタスクの開始を通知(1)
        self._bgTask = app.beginBackgroundTaskWithExpirationHandler() {
            println("10分以内に処理が完了しなかったとき")
            
            //バックグラウンドタスクの終了を通知
            self.finishBackgroundTask()
        }
        
        //バックグラウンドタスクの処理を実行
        dispatch_async(dispatch_get_global_queue(
            DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            //バックグラウンドタスクの記述
            println("バックグラウンドタスクの内容をここに記述")
                
            //ローカルノーティフィケーションの表示(5)
            let notification = UILocalNotification()
            notification.alertBody = "バックグラウンドタスクが完了"
            notification.alertAction = "OK"
            notification.soundName = UILocalNotificationDefaultSoundName;
            notification.fireDate = NSDate(timeInterval: 10, sinceDate: NSDate())
            notification.timeZone = NSTimeZone.defaultTimeZone()
            app.presentLocalNotificationNow(notification)
                
            //バックグラウンドタスクの終了を通知
            self.finishBackgroundTask()
        })
    }
    
    //バックグラウンドタスクの終了を通知(2)
    func finishBackgroundTask() {
        if _bgTask != nil {
            UIApplication.sharedApplication().endBackgroundTask(_bgTask!)
            _bgTask = nil
        }
    }
    
    //フォアグラウンド遷移時に呼ばれる
    func applicationWillEnterForeground(application: UIApplication) {
        println("applicationWillEnterForeground")
    }
    
    //アプリ復帰時に呼ばれる
    func applicationDidBecomeActive(application: UIApplication) {
        println("applicationDidBecomeActive")
    }
    
    //アプリ終了時に呼ばれる
    func applicationWillTerminate(application: UIApplication) {
        println("applicationWillTerminate")
    }
}

