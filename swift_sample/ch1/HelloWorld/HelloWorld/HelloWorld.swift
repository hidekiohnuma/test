import UIKit

//HelloWorld
class HelloWorld: UIView { //(4)
    //描画時に呼ばれる
    override func drawRect(rect: CGRect) {
        //文字列の描画
        let attrs = [NSFontAttributeName: UIFont.systemFontOfSize(24)] 
        let str = "Hello, World!"
        let nsstr = str as NSString
        nsstr.drawAtPoint(CGPointMake(0, 20), withAttributes: attrs)
    }
}
