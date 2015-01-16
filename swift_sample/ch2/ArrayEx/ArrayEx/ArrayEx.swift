import UIKit

//配列と連想配列
class ArrayEx: UIView {
    
    //描画時に呼ばれる
    override func drawRect(rect: CGRect) {
        //配列の生成(1)
        var array: Array<String> = Array<String>()
        
        //配列の要素の追加(2)
        array.append("iPhone")
        array.append("iPad")
        array.append("iPod touch")
        
        //配列の要素の変更(3)
        array[2] = "AppleTV"
        
        //配列の要素の取得(4)
        for var i = 0; i < 3; i++ {
            drawString(array[i], x: 0, y: 20+i*26)
        }
        
        //配列の要素の取得(4)
        for element in array {
            println(element);
        }
        
        //連想配列の生成(5)
        var dictionary: Dictionary<String, String> =
            Dictionary<String, String>()
        
        //連想配列の要素の追加(6)
        dictionary["Phone"] = "iPhone"
        dictionary["Tablet"] = "iPad"
        dictionary["MusicPlayer"] = "iPod touch"
        
        //連想配列の要素の変更(7)
        dictionary["MusicPlayer"] = "AppleTV"
        
        
        //連想配列の要素の取得(8)
        drawString(dictionary["Phone"]!, x :0, y: 20+4*26)
        drawString(dictionary["Tablet"]!, x :0, y: 20+5*26)
        drawString(dictionary["MusicPlayer"]!, x :0, y: 20+6*26)
    }
    
    //文字列の描画
    func drawString(str: String, x: Int, y: Int) {
        let attrs = [NSFontAttributeName:UIFont.systemFontOfSize(24)]
        let nsstr = str as NSString
        nsstr.drawAtPoint(CGPointMake(CGFloat(x), CGFloat(y)),
            withAttributes: attrs)
    }
}
