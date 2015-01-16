import UIKit

//トランジション
class ViewController: UIViewController {
    var _imageView: UIImageView? //イメージビュー
    var _animeIdx = 1           //アニメーションインデックス
    
    //ロード完了時に呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()

        //イメージビューの生成
        _imageView = makeImageView(self.view.frame, idx: 0)
        self.view.addSubview(_imageView!)
    }
    
    //タッチ終了時に呼ばれる
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        //ビューの生成(2)
        let nextView = makeImageView(self.view.frame, idx: _animeIdx%2)
    
        //UIViewアニメーションの設定開始
        UIView.beginAnimations("transition", context: nil)
        UIView.setAnimationDuration(1.0)
    
        //トランジションアニメーションの設定(1)
        var transition = UIViewAnimationTransition.FlipFromLeft
        if _animeIdx == 2 {transition = UIViewAnimationTransition.FlipFromRight}
        if _animeIdx == 3 {transition = UIViewAnimationTransition.CurlUp}
        if _animeIdx == 4 {transition = UIViewAnimationTransition.CurlDown}
        UIView.setAnimationTransition(transition, forView: self.view, cache: true)
    
        //ビューの変更(2)
        _imageView?.removeFromSuperview()
        _imageView = nextView
        self.view.addSubview(_imageView!)
    
        //UIViewアニメーションの実行
        UIView.commitAnimations()
    
        //アニメーションINDEXの遷移
        _animeIdx++
        if _animeIdx > 4 {_animeIdx = 1}
    }
    
    //イメージビューの生成
    func makeImageView(rect: CGRect, idx: Int) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "sample\(idx).png")
        imageView.frame = rect
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.backgroundColor = UIColor.whiteColor()
        imageView.autoresizingMask =
            UIViewAutoresizing.FlexibleRightMargin |
            UIViewAutoresizing.FlexibleTopMargin |
            UIViewAutoresizing.FlexibleLeftMargin |
            UIViewAutoresizing.FlexibleBottomMargin |
            UIViewAutoresizing.FlexibleWidth |
            UIViewAutoresizing.FlexibleHeight
        return imageView
    }
}
