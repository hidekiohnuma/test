import UIKit

//イメージの描画
class ImageEx: UIView {
    var _image: UIImage? //イメージ
    
    //初期化
    required init(coder: NSCoder) {//(4)
        super.init(coder: coder)
        
        //画像ファイルの読み込み(1)
        _image = UIImage(named: "sample.png")
    }
    
    //描画時に呼ばれる
    override func drawRect(rect: CGRect) {
        //イメージの描画(2)
        _image?.drawAtPoint(CGPointMake(0, 20))
        
        //イメージの拡大縮小描画(3)
        var w = _image!.size.width
        var h = _image!.size.height
        _image?.drawInRect(CGRectMake(0, 180, w*2, h*2))
    }
}
