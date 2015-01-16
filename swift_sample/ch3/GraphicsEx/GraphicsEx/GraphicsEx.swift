import UIKit

//図形の描画
class GraphicsEx: UIView {
    var _context: CGContextRef? //グラフィックスコンテキスト
    
    //色の指定(2)
    func setColor(r: Int, g: Int, b: Int) {
        CGContextSetRGBFillColor(_context,
            CGFloat(r)/255.0, CGFloat(g)/255.0, CGFloat(b)/255.0, 1.0)
        CGContextSetRGBStrokeColor(_context,
            CGFloat(r)/255.0, CGFloat(g)/255.0, CGFloat(b)/255.0, 1.0)
    }
    
    //ライン幅の指定(3)
    func setLineWidth(width: Float) {
        CGContextSetLineWidth(_context, CGFloat(width))
    }
    
    //ラインの描画(3)
    func drawLine(x0: Float, y0: Float, x1: Float, y1: Float) {
        CGContextSetLineCap(_context,kCGLineCapRound)
        CGContextMoveToPoint(_context, CGFloat(x0), CGFloat(y0))
        CGContextAddLineToPoint(_context, CGFloat(x1), CGFloat(y1))
        CGContextStrokePath(_context)
    }
    
    //ポリラインの描画(3)
    func drawPolyline(x: Array<Float>, y: Array<Float>) {
        CGContextSetLineCap(_context, kCGLineCapRound)
        CGContextSetLineJoin(_context, kCGLineJoinRound)
        CGContextMoveToPoint(_context, CGFloat(x[0]), CGFloat(y[0]))
        for (var i = 1; i < x.count; i++) {
            CGContextAddLineToPoint(_context, CGFloat(x[i]), CGFloat(y[i]))
        }
        CGContextStrokePath(_context)
    }
    
    //四角形の描画(4)
    func drawRect(x: Float, y: Float, w: Float, h: Float) {
        CGContextMoveToPoint(_context, CGFloat(x), CGFloat(y))
        CGContextAddLineToPoint(_context, CGFloat(x+w), CGFloat(y))
        CGContextAddLineToPoint(_context, CGFloat(x+w), CGFloat(y+h))
        CGContextAddLineToPoint(_context, CGFloat(x), CGFloat(y+h))
        CGContextAddLineToPoint(_context, CGFloat(x), CGFloat(y))
        CGContextAddLineToPoint(_context, CGFloat(x+w), CGFloat(y))
        CGContextStrokePath(_context)
    }
    
    //四角形の塗り潰し(4)
    func fillRect(x: Float, y: Float, w: Float, h: Float) {
        CGContextFillRect(_context,
            CGRectMake(CGFloat(x), CGFloat(y), CGFloat(w), CGFloat(h)))
    }
    
    //円の描画(5)
    func drawCircle(x: Float, y: Float, w: Float, h: Float) {
        CGContextAddEllipseInRect(_context,
            CGRectMake(CGFloat(x), CGFloat(y), CGFloat(w), CGFloat(h)))
        CGContextStrokePath(_context)
    }
    
    //円の塗り潰し(5)
    func fillCircle(x: Float, y: Float, w: Float, h: Float) {
        CGContextFillEllipseInRect(_context,
            CGRectMake(CGFloat(x), CGFloat(y), CGFloat(w), CGFloat(h)))
    }
    
    //描画
    override func drawRect(rect:  CGRect) {
        //グラフィックスコンテキストの取得(1)
        _context = UIGraphicsGetCurrentContext()
        
        //色の指定(2)
        setColor(255, g: 255, b: 255)
        
        //背景のクリア
        let w = Float(self.frame.size.width)
        let h = Float(self.frame.size.height)
        fillRect(0, y: 0, w: w, h: h)
        
        //ラインの描画(3)
        setColor(255, g: 0, b: 0)
        setLineWidth(2)
        drawLine(25, y0: 25, x1: 25, y1: 25+40)
        
        //ポリラインの描画(3)
        let dx: Array<Float> = [55, 85, 65, 95, 55]
        let dy: Array<Float> = [25, 30, 45, 50, 65]
        setColor(255, g: 0, b: 0)
        setLineWidth(3)
        drawPolyline(dx, y: dy)
        
        //四角形の描画(4)
        setColor(0, g: 255, b: 0)
        setLineWidth(1)
        drawRect(5, y: 70, w: 40, h: 40)
        
        //四角形の塗り潰し(4)
        setColor(0, g: 255, b: 0)
        setLineWidth(1)
        fillRect(55, y: 70, w: 40, h: 40)
        
        //円の描画(5)
        setColor(0, g: 0, b: 255)
        drawCircle(5, y: 120, w: 40, h: 40)
        
        //円の塗り潰し(5)
        setColor(0, g: 0, b: 255)
        fillCircle(55, y: 120, w: 40, h: 40)
    }
}
