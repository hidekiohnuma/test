import UIKit
import CoreLocation

//位置情報
class ViewController: UIViewController,
    CLLocationManagerDelegate {
    var _label:UILabel?                     //ラベル
    var _locationManager:CLLocationManager? //ロケーションマネージャ
    var _latitude:CLLocationDegrees = 0.0   //緯度
    var _longitude:CLLocationDegrees = 0.0  //経度
    var _heading:CLLocationDirection = 0.0  //ヘッダ

//====================
//UI
//====================
    //ロード完了時に呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ラベルの生成
        _label = makeLabel(CGPointMake(0, 20),
            text: "LocationEx", font: UIFont.systemFontOfSize(24))
        self.view.addSubview(_label!)
        
        //ロケーションマネージャーの生成(1)
        _locationManager = CLLocationManager()
        _locationManager?.requestAlwaysAuthorization()
        _locationManager?.delegate = self
        
        //位置情報通知の開始(2)
        if CLLocationManager.locationServicesEnabled() {
            _locationManager?.startUpdatingLocation()
        }
        
        //方位情報通知の開始(3)
        if CLLocationManager.headingAvailable() {
            _locationManager?.startUpdatingHeading()
        }
        
        //タイマーの生成
        NSTimer.scheduledTimerWithTimeInterval(0.1,
            target: self, selector: "onTick:",
            userInfo: nil, repeats: true)
    }
    
    //定期処理
    func onTick(timer: NSTimer) {
        //文字列の生成
        var str = NSMutableString()
        str.appendString("LocationEx\n")
        str.appendFormat("緯度:%+f\n", _latitude)
        str.appendFormat("経度:%+f\n", _longitude)
        str.appendFormat("方位:%+3.2f\n", _heading)
        
        //ラベルの更新
        _label!.text = str
        _label!.frame.size.width = 9999
        _label!.frame.size.height = 9999
        _label?.sizeToFit()
    }
    
    //ラベルの生成
    func makeLabel(pos: CGPoint, text: NSString, font: UIFont) -> UILabel {
        var label = UILabel()
        label.frame = CGRectMake(pos.x, pos.y, 9999, 9999)
        label.text = text
        label.font = font
        label.textAlignment = NSTextAlignment.Left
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.numberOfLines = 0
        label.sizeToFit()
        return label
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
//CLLocationManagerDelegate
//====================
    //位置情報更新時に呼ばれる(4)
    func locationManager(manager: CLLocationManager!,
        didUpdateLocations locations: [AnyObject]!) {
        //位置情報の取得(5)
        let location = locations[0] as CLLocation
        _latitude = location.coordinate.latitude
        _longitude = location.coordinate.longitude
    }
    
    //位置情報取得失敗時に呼ばれる(4)
    func locationManager(manager: CLLocationManager!,
        didFailWithError error: NSError!) {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.showAlert(nil, text: "位置情報取得に失敗しました")
        }
    }
    
    //方位情報更新時に呼ばれる(4)
    func locationManager(manager: CLLocationManager!,
        didUpdateHeading newHeading: CLHeading!) {
        //方位情報の取得(6)
        _heading = newHeading.trueHeading
    }
}
