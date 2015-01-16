import UIKit
import QuartzCore

//レイヤーアニメーション
class ViewController: UIViewController {
    
    //ロード完了時に呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        let w: CGFloat = UIScreen.mainScreen().bounds.size.width
        let h: CGFloat = UIScreen.mainScreen().bounds.size.height

        //イメージの読み込み
        let image = UIImage(named: "sample.png")
        
        //レイヤーの生成(1)
        let layer = CALayer()
        layer.frame = CGRectMake(0, 0, 80, 80)
        layer.position = CGPointMake(w/2, h/2)
        layer.contents = image!.CGImage
        
        //ビューへのレイヤーの追加(2)
        self.view.layer.addSublayer(layer)
        
        //レイヤーアニメーションの生成(3)
        let anime = CABasicAnimation(keyPath: "transform")
        anime.duration = 0.5
        anime.repeatCount = 999
        anime.autoreverses = true
        anime.fromValue = NSValue(CATransform3D: CATransform3DIdentity)
        anime.toValue = NSValue(CATransform3D:
            CATransform3DMakeRotation(CGFloat(M_PI), 0, 1, 0)) //(4)
        
        //レイヤーへのレイヤーアニメーションの追加(5)
        layer.addAnimation(anime, forKey: "rotation")
    }
}
