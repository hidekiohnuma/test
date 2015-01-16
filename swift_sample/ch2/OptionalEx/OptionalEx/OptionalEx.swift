import UIKit

//オプショナル
class OptionalEx: UIView {
    
    //描画時に呼ばれる
    override func drawRect(rect: CGRect) {
        //オプショナルな型の変数の定義(1)
        var str: String? = nil //オプショナルな型にはnilを代入できる
        
        //通常の型の変数にオプショナルな型の変数を代入(2)
        var optionalValue: Int? = 10
        var newValue: Int
        if let value = optionalValue {
            newValue = value
            drawString("オプショナルな型の変数=\(value)", x: 0, y: 20)
        }
        
        //オプショナルな型の変数のプロパティ利用(3)
        drawString("変数のプロパティ利用", x: 0, y: 20+2*26)
        var str0: String? = "3"
        var result0:Bool? = str0?.isEmpty
        drawString("nilでないとき:\(result0)", x: 0, y: 20+3*26)
        var str1: String? = nil
        var result1:Bool? = str1?.isEmpty
        drawString("nilのとき:\(result1)", x: 0, y: 20+4*26)
        
        //オプショナルな型の変数のメソッド利用(4)
        drawString("変数のメソッド利用", x: 0, y: 20+6*26)
        var str2: String? = "3"
        var result2:Int? = str2?.toInt()
        drawString("nilでないとき:\(result2)", x: 0, y: 20+7*26)
        var str3: String? = nil
        var result3:Int? = str3?.toInt()
        drawString("nilのとき:\(result3)", x: 0, y: 20+8*26)
    }
    
    //文字列の描画
    func drawString(str: String, x: Int, y: Int) {
        let attrs = [NSFontAttributeName:UIFont.systemFontOfSize(24)]
        let nsstr = str as NSString
        nsstr.drawAtPoint(CGPointMake(CGFloat(x), CGFloat(y)),
            withAttributes: attrs)
    }
}
