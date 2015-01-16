import UIKit

//タイマーの処理
class TimerEx: UIView {
    var _timer: NSTimer? //タイマー
    var _image: UIImage? //イメージ
    var _px = 0          //X座標
    var _py = 0          //Y座標
    var _vx = 4          //X速度
    var _vy = 4          //Y速度
    
    //初期化
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        //画像の読み込み
        _image = UIImage(named: "sample.png")
        
        //XY座標の初期化
        _px = Int(UIScreen.mainScreen().bounds.size.width/2)
        _py = Int(UIScreen.mainScreen().bounds.size.height/2)
        
    }
    
    //描画時に呼ばれる
    override func drawRect(rect: CGRect) {
        //イメージの描画
        _image?.drawAtPoint(CGPointMake(CGFloat(_px)-40, CGFloat(_py)-40))
    }
    
    //タッチ終了時に呼ばれる
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        if _timer == nil {
            //タイマーの生成(1)
            _timer = NSTimer.scheduledTimerWithTimeInterval(1.0/30.0,
                target: self,
                selector: "onTick:",
                userInfo: nil,
                repeats: true)
        } else {
            //タイマーの停止(2)
            _timer?.invalidate()
            _timer = nil
        }
    }
    
    //定期処理(3)
    func onTick(timer: NSTimer) {
        //移動
        _px += _vx//X座標
        _py += _vy//Y座標
        if _px < 0 {_vx =  4}                           //左端反転
        if Int(self.bounds.size.width) < _px {_vx = -4} //右端反転
        if _py < 0 {_vy =  4}                           //上端反転
        if Int(self.bounds.size.height) < _py {_vy = -4}//下端反転
    
        //再描画
        self.setNeedsDisplay()
    }
}
