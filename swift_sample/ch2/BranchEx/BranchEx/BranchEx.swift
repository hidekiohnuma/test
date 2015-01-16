import UIKit

//条件分岐
class BranchEx: UIView {
    
    //描画時に呼ばれる
    override func drawRect(rect: CGRect) {
        //乱数の取得(1)
        let num = Int(arc4random()%4)
        
        //if文による計算(2)
        var text0 = ""
        if num == 0 {
            text0 = "大吉"
        } else if num == 1 {
            text0 = "中吉"
        } else if num == 2 {
            text0 = "小吉"
        } else {
            text0 = "凶"
        }
        
        //switch文による計算(3)
        var text1 = ""
        switch num {
        case 0:
            text1 = "大吉"
        case 1:
            text1 = "中吉"
        case 2:
            text1 = "小吉"
        default:
            text1 = "凶"
        }
        
        //表示
        drawString("ifの計算結果:\(text0)", x: 0, y: 20)
        drawString("switchの計算結果:\(text1)", x: 0, y: 20+26)
    }
    
    //文字列の描画
    func drawString(str: String, x: Int, y: Int) {
        let attrs = [NSFontAttributeName:UIFont.systemFontOfSize(24)]
        let nsstr = str as NSString
        nsstr.drawAtPoint(CGPointMake(CGFloat(x), CGFloat(y)),
            withAttributes: attrs)
    }
}
