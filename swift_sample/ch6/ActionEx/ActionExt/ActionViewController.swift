import UIKit
import MobileCoreServices

//アクションビューコントローラ
class ActionViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView! //イメージビュー

    //ロード完了時に呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //)NSItemProviderオブジェクトの取得(4)
        let extensionItem = self.extensionContext!.inputItems[0]
            as NSExtensionItem
        let itemProvider = extensionItem.attachments![0] as NSItemProvider
        
        //画像の取り出し(4)
        if itemProvider.hasItemConformingToTypeIdentifier(
            kUTTypeImage as NSString) {
            weak var weakImageView = self.imageView
            itemProvider.loadItemForTypeIdentifier(
                kUTTypeImage as NSString, options: nil,
                completionHandler: {(item: NSSecureCoding!, error: NSError!) in
                    if item != nil {
                        //イメージを反転
                        let invertedImage = self.invertedImage(item as UIImage)
                        
                        //イメージビューに表示
                        NSOperationQueue.mainQueue().addOperationWithBlock {
                            if let imageView = weakImageView {
                                imageView.image = invertedImage
                            }
                        }
                    }
                })
            return
        }
    }
    
    //イメージの反転(5)
    func invertedImage(image: UIImage) -> UIImage {
        UIGraphicsBeginImageContext(image.size)
        let context = UIGraphicsGetCurrentContext()
        let affineTransformationInvert = CGAffineTransformMake(
            1, 0, 0, -1, 0, image.size.height)
        CGContextConcatCTM(context, affineTransformationInvert)
        image.drawAtPoint(CGPointMake(0, 0))
        let invertedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return invertedImage
    }
    

    //Doneボタン押下時に呼ばれる
    @IBAction func done() {
        //Extentionアイテムを生成してHome appに返す(6)
        let extensionItem = NSExtensionItem()
        extensionItem.attachments = [NSItemProvider(item:self.imageView.image,
            typeIdentifier: kUTTypeImage as NSString)]
        self.extensionContext!.completeRequestReturningItems([extensionItem],
            completionHandler: nil)
    }

}
