import UIKit

//ドキュメント
class ICloudDocument: UIDocument {
    var text = "" //テキスト
    
    //ドキュメント読み込み時に呼ばれる(6)
    override func loadFromContents(contents: AnyObject, ofType
        typeName: String, error outError: NSErrorPointer) -> Bool {
        self.text = NSString(data: contents as NSData,
            encoding: NSUTF8StringEncoding)!
        return true
    }
    
    //ドキュメント書き込み時に呼ばれる(7)
    override func contentsForType(typeName: String,
        error outError: NSErrorPointer) -> AnyObject? {
        return self.text.dataUsingEncoding(NSUTF8StringEncoding)
    }
}
