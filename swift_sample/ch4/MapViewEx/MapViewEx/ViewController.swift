import UIKit
import MapKit //(1)

//マップビュー
class ViewController: UIViewController, MKMapViewDelegate {
    var _mapView: MKMapView? //マップビュー
    
//====================
//UI
//====================
    //ロード完了時に呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()

        //マップビューの生成(1)
        _mapView = makeMapView(self.view.frame)
        self.view.addSubview(_mapView!)
        
        //位置の値の用意(2)
        var coordinate = CLLocationCoordinate2D(
            latitude: 35.707527, longitude: 139.760857)
        
        //ズームの値の用意(3)
        var span = MKCoordinateSpan(
            latitudeDelta: 0.01, longitudeDelta: 0.01)
        
        //位置とズームの値の指定(4)
        var region = MKCoordinateRegion(center: coordinate, span: span)
        _mapView?.setRegion(region, animated: true)
    }
    
    //マップビューの生成(1)
    func makeMapView(frame: CGRect) -> MKMapView {
        let mapView = MKMapView()
        mapView.frame = frame
        mapView.mapType = MKMapType.Standard
        mapView.autoresizingMask =
            UIViewAutoresizing.FlexibleRightMargin |
            UIViewAutoresizing.FlexibleTopMargin |
            UIViewAutoresizing.FlexibleLeftMargin |
            UIViewAutoresizing.FlexibleBottomMargin |
            UIViewAutoresizing.FlexibleWidth |
            UIViewAutoresizing.FlexibleHeight
        mapView.delegate = self
        return mapView;
    }
    
//====================
//MKMapViewDelegate
//====================
    //マップロード成功時に呼ばれる(5)
    func mapViewDidFinishLoadingMap(mapView: MKMapView!) {
        println("マップロード成功")
    }
    
    //マップロード失敗時に呼ばれる(5)
    func mapViewDidFailLoadingMap(mapView: MKMapView!,
        withError error: NSError!) {
        println("マップロード失敗")
    }
}
