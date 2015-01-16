import UIKit
import MobileCoreServices

//アクション
class ViewController: UIViewController {
    //定数
    let BTN_ACTION = 0 //アクション
    
    //変数
    var _imageView: UIImageView? //イメージビュー
    
    //ロード完了時に呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        let dx: CGFloat = (UIScreen.mainScreen().bounds.size.width-320)/2
        
        //イメージビューの生成
        _imageView = makeImageView(CGRectMake(dx+120, 20, 80, 80),
            image: UIImage(named: "sample.png")!)
        self.view.addSubview(_imageView!)
        
        //アラート表示ボタンの生成
        let btnAlert = makeButton(CGRectMake(dx+60, 120, 200, 40),
            text: "Action", tag: BTN_ACTION)
        self.view.addSubview(btnAlert)
    }
    
    //イメージビューの生成
    func makeImageView(frame: CGRect, image: UIImage) -> UIImageView {
        let imageView = UIImageView()
        imageView.frame = frame
        imageView.image = image
        return imageView
    }
    
    //ボタンクリック時に呼ばれる
    func onClick(sender: UIButton) {
        if sender.tag == BTN_ACTION {
            dispatch_async(dispatch_get_global_queue(
                DISPATCH_QUEUE_PRIORITY_DEFAULT,0), {
                //アクティビティビューを開く(1)
                let activityViewController = UIActivityViewController(
                    activityItems: [self._imageView!.image!],
                    applicationActivities: nil)
                activityViewController.completionWithItemsHandler = {
                    (activityType: String!, completed: Bool,
                    returnedItems: Array!, error: NSError!) in
                    if activityType == "net.npaka.ActionEx.ActionExt" &&
                        completed {
                        //)NSItemProviderオブジェクトの取得(2)
                        let extensionItem = returnedItems[0] as NSExtensionItem
                        let itemProvider = extensionItem.attachments![0]
                            as NSItemProvider
                    
                        //画像の取り出し(3)
                        if itemProvider.hasItemConformingToTypeIdentifier(
                            kUTTypeImage as NSString) {
                            itemProvider.loadItemForTypeIdentifier(
                                kUTTypeImage as NSString!, options:nil,
                                completionHandler: {
                                    (item: NSSecureCoding!, error: NSError!) in
                                    dispatch_async(dispatch_get_main_queue(), {
                                        self._imageView!.image = item as? UIImage
                                    })
                                })
                        }
                    }
                }
                self.presentViewController(activityViewController,
                    animated: true, completion: nil)
            })
        }
    }
    
    //ボタンの生成
    func makeButton(frame: CGRect, text: NSString, tag: Int) -> UIButton {
        let button = UIButton.buttonWithType(UIButtonType.System) as UIButton
        button.frame = frame
        button.setTitle(text, forState: UIControlState.Normal)
        button.tag = tag
        button.addTarget(self, action: "onClick:",
            forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }
}
