import UIKit

//タッチイベントの処理
class TouchEx: UIView {
    var _touches = [UITouch]() //タッチオブジェクト群
    
    //初期化
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        //マルチタッチの有効化(1)
        self.multipleTouchEnabled = true
    }
    
    //描画時に呼ばれる
    override func drawRect(rect: CGRect) {
        drawString("TouchEx>", x: 0, y: 20)
        
        //タッチ位置の描画(5)
        for var i = 0; i < _touches.count; i++ {
            let pos = _touches[i].locationInView(self)
            let str = "touchPos[\(i)]=(\(Int(pos.x)),\(Int(pos.y)))\n";
            drawString(str, x: 0, y: 20+26+26*i)
        }
    }
    
    //タッチ開始時に呼ばれる(2)
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        //タッチオブジェクトの取得(3)
        let objects = touches.allObjects
        for var i = 0; i < objects.count; i++ {
            _touches.append(objects[i] as UITouch)
        }
    
        //再描画(4)
        self.setNeedsDisplay()
    }
    
    //タッチ移動時に呼ばれる(2)
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        //再描画(4)
        self.setNeedsDisplay()
    }
    
    //タッチ終了時に呼ばれる(2)
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        //タッチオブジェクトの削除(3)
        let objects = touches.allObjects
        for var j = 0; j < objects.count; j++ {
            for var i = 0; i < _touches.count; i++ {
                if objects[j] as UITouch == _touches[i] {
                    _touches.removeAtIndex(i)
                    break
                }
            }
        }
    
        //再描画(4)
        self.setNeedsDisplay()
    }
    
    //タッチキャンセル時に呼ばれる(2)
    override func touchesCancelled(touches: NSSet, withEvent event: UIEvent) {
        //タッチオブジェクトの削除(3)
        _touches.removeAll()
    
        //再描画(4)
        self.setNeedsDisplay()
    }
    
    //文字列の描画
    func drawString(str: String, x: Int, y: Int) {
        let attrs = [NSFontAttributeName: UIFont.systemFontOfSize(24)]
        let nsstr = str as NSString
        nsstr.drawAtPoint(CGPointMake(CGFloat(x), CGFloat(y)),
            withAttributes: attrs)
    }
}
