import UIKit

//グラフィックス
class Graphics {
    var _context: CGContextRef? //コンテキスト
    var _attrs: [NSString: NSObject] = [ //属性
        NSFontAttributeName: UIFont.systemFontOfSize(12),
        NSForegroundColorAttributeName: UIColor.blackColor()]
    
    //初期化
    init() {
    }
    
    //====================
    //アクセス
    //====================
    //コンテキストの指定
    func setContext(context: CGContextRef) {
        _context = context;
    }
    
    //色の指定
    func setColor(r: CGFloat, _ g: CGFloat, _ b: CGFloat) {
        CGContextSetRGBFillColor(_context, r, g, b, 1.0)
        CGContextSetRGBStrokeColor(_context, r, g, b, 1.0)
        _attrs[NSForegroundColorAttributeName] =
            UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    //フォントの指定
    func setFont(font: UIFont) {
        _attrs[NSFontAttributeName] = font
    }
    
    //ライン幅の指定
    func setLineWidth(lineWidth: CGFloat) {
        CGContextSetLineWidth(_context, lineWidth)
    }
    
    //スケールの指定
    func setScale(scaleX: CGFloat, _ scaleY: CGFloat) {
        CGContextScaleCTM(_context, scaleX, scaleY)
    }
    
    //文字列サイズの取得
    func getStringSize(str: String) -> CGSize {
        let nsstr = str as NSString
        return nsstr.sizeWithAttributes(_attrs)
    }
    
    //====================
    //描画
    //====================
    //ラインの描画
    func drawLine(x0: CGFloat, _ y0: CGFloat, _ x1: CGFloat, _ y1: CGFloat) {
        CGContextSetLineCap(_context, kCGLineCapRound)
        CGContextMoveToPoint(_context, x0, y0)
        CGContextAddLineToPoint(_context, x1, y1)
        CGContextStrokePath(_context)
    }
    
    
    //矩形の描画
    func drawRect(x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h:CGFloat) {
        CGContextMoveToPoint(_context, x, y)
        CGContextAddLineToPoint(_context, x+w, y)
        CGContextAddLineToPoint(_context, x+w, y+h)
        CGContextAddLineToPoint(_context, x, y+h)
        CGContextAddLineToPoint(_context, x, y)
        CGContextAddLineToPoint(_context, x+w, y)
        CGContextStrokePath(_context)
    }
    
    //矩形の塗り潰し
    func fillRect(x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat) {
        CGContextFillRect(_context, CGRectMake(x, y, w, h))
    }
    
    //イメージの描画
    func drawImage(image: UIImage, _ x: CGFloat, _ y: CGFloat) {
        image.drawAtPoint(CGPointMake(x, y))
    }
    
    //イメージの描画
    func drawImage(image: UIImage, _ x: CGFloat, _ y: CGFloat,
        _ w: CGFloat, _ h: CGFloat) {
        image.drawInRect(CGRectMake(x, y, w, h))
    }
    
    //文字列の描画
    func drawString(str: String, _ x: CGFloat, _ y: CGFloat) {
        str.drawAtPoint(CGPointMake(x, y), withAttributes:_attrs)
    }
}