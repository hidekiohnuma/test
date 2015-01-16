import UIKit

//ビューアニメーション
class ViewController: UIViewController {
    //定数
    let BTN_MOVE = 0 //移動
    
    //変数
    var _imageView: UIImageView? //イメージビュー
    var _animeIdx = 1            //アニメインデックス

    //ロード完了時に呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        let dx: CGFloat = (UIScreen.mainScreen().bounds.size.width-320)/2

        //イメージビューの生成
        _imageView = makeImageView(CGRectMake(dx+40, 60, 240, 240),
            image: UIImage(named: "sample.png")!)
        self.view.addSubview(_imageView!)
        
        //ボタンの生成
        let button = makeButton(CGRectMake(dx+60, 360, 200, 40),
            text: "UIViewアニメーション", tag: BTN_MOVE)
        self.view.addSubview(button)
    }
    
    //ボタンクリック時に呼ばれる
    func onClick(sender: UIButton) {
        let dx: CGFloat = (UIScreen.mainScreen().bounds.size.width-320)/2
        if sender.tag == BTN_MOVE {
            //アニメーション前の平行緯度・回転角度・透明度の指定(1)
            if _animeIdx == 1 {
                _imageView!.transform = CGAffineTransformMakeScale(0.5, 0.5)
                _imageView!.alpha = 0.8
            } else if _animeIdx == 2 {
                var trans = CGAffineTransformMakeRotation(
                    CGFloat(180.0*(M_PI/180.0)))
                _imageView!.transform = CGAffineTransformScale(trans, 0.5, 0.5)
                _imageView!.alpha = 0.8
            } else if _animeIdx == 3 {
                _imageView!.transform = CGAffineTransformMakeTranslation(0, 400)
                _imageView!.alpha = 0.8
            } else if _animeIdx == 4 {
                _imageView!.frame = CGRectMake(dx+60, 340, 200, 40) //(6)
            }
            
            //UIViewアニメーションの設定(2)
            UIView.beginAnimations("anime0", context:nil)
            UIView.setAnimationDuration(0.5)
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
            UIView.setAnimationRepeatCount(0)
            UIView.setAnimationRepeatAutoreverses(false)
            
            //UIViewアニメーションのデリゲートの指定(3)
            UIView.setAnimationDelegate(self)
            UIView.setAnimationWillStartSelector("someAnimationWillStart:")
            UIView.setAnimationDidStopSelector(
                "someAnimationDidStop:finished:context:")
            
            //アニメーション後の平行移動・回転角度・透明度の指定(4)
            if _animeIdx == 1 || _animeIdx == 2 || _animeIdx == 3 {
                _imageView!.transform = CGAffineTransformIdentity
                _imageView!.alpha = 1.0
            } else if _animeIdx == 4 {
                _imageView!.frame = CGRectMake(dx+40, 40, 240, 240) //(6)
            }
            
            //UIViewアニメーションの実行(5)
            UIView.commitAnimations()
            
            //アニメーションINDEXの遷移
            _animeIdx++
            if _animeIdx > 4 {
                _animeIdx = 1
            }
        }
    }
    
    //テキストボタンの生成
    func makeButton(frame: CGRect, text: NSString, tag: Int) -> UIButton {
        let button = UIButton.buttonWithType(UIButtonType.System) as UIButton
        button.frame = frame
        button.setTitle(text, forState: UIControlState.Normal)
        button.tag = tag
        button.addTarget(self, action: "onClick:",
            forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }
    
    //イメージビューの生成
    func makeImageView(frame: CGRect, image: UIImage) -> UIImageView {
        let imageView = UIImageView()
        imageView.frame = frame
        imageView.image = image
        return imageView
    }
    
    //アニメーション開始時に呼ばれる
    func someAnimationWillStart(sender: AnyObject) {
        println("アニメ−ション開始");
    }
    
    //アニメーション停止時に呼ばれる
    func someAnimationDidStop(animationID: String, finished: Bool,
        context: AnyObject) {
        println("アニメ−ション停止");
    }
}
