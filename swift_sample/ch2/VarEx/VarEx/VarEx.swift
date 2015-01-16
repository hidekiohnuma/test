import UIKit

//変数
class VarEx: UIView {
    
    //描画時に呼ばれる
    override func drawRect(rect: CGRect) {
        //変数の定義(1)
        var num0: Int //数値0
        var num1: Int //数値1
        var sum: Int  //合計
        
        //値の代入(2)
        num0 = 100         //数値0に100を代入
        num1 = 200         //数値1に200を代入
        sum  = num0 + num1 //数値0+数値1の計算結果を代入(3)
        
        //文字列の生成
        var str: String = "合計=\(sum)"
        
        //文字列の描画(4)
        drawString(str, x: 0, y: 20);
    }
    
    //文字列の描画(5)
    func drawString(str: String, x: Int, y: Int) {
        let attrs = [NSFontAttributeName: UIFont.systemFontOfSize(24)]
        let nsstr = str as NSString
        nsstr.drawAtPoint(CGPointMake(CGFloat(x), CGFloat(y)),
            withAttributes: attrs)
    }
}
