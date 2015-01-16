import UIKit

//オブジェクト
class ObjectEx: UIView {
    
    //描画時に呼ばれる
    override func drawRect(rect: CGRect) {
        //オブジェクト型の変数の定義(1)(2)
        let calendar: NSCalendar =
            NSCalendar(calendarIdentifier: NSGregorianCalendar)!
        
        //取得情報フラグの準備(3)
        let flags =
            NSCalendarUnit.YearCalendarUnit |  //年
            NSCalendarUnit.MonthCalendarUnit | //月
            NSCalendarUnit.DayCalendarUnit |   //日
            NSCalendarUnit.HourCalendarUnit |  //時
            NSCalendarUnit.MinuteCalendarUnit  //分
        
        //日付コンポーネントの取得(4)
        let comps = calendar.components(flags, fromDate: NSDate())
        
        //年月日の取得(5)
        let year = comps.year     //年
        let month = comps.month   //月
        let day = comps.day       //日
        let hour = comps.hour     //時
        let minute = comps.minute //分
        
        //文字列の描画
        var str = "\(year)年\(month)月\(day)日 \(hour)時\(minute)分"
        drawString(str, x: 0, y: 20)
    }
    
    //文字列の描画
    func drawString(str: String, x: Int, y: Int) {
        let attrs = [NSFontAttributeName: UIFont.systemFontOfSize(24)]
        let nsstr = str as NSString
        nsstr.drawAtPoint(CGPointMake(CGFloat(x), CGFloat(y)),
            withAttributes: attrs)
    }
}
