import UIKit

//カメラ
class ViewController: UIViewController,
    UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    //定数
    let BTN_CAMERA = 0 //カメラ
    let BTN_READ   = 1 //フォト読み込み
    let BTN_WRITE  = 2 //フォト書き込み
    
    //変数
    var _imageView: UIImageView? //イメージビュー
    var _btnCamera: UIButton?    //カメラボタン
    var _btnRead: UIButton?      //フォト読み込みボタン
    var _btnWrite: UIButton?     //フォト書き込みボタン

//====================
//UI
//====================
    //ロード完了時に呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        let dx: CGFloat = (UIScreen.mainScreen().bounds.size.width-320)/2
        
        //カメラボタンの生成
        _btnCamera = makeButton(CGRectMake(dx+60, 20, 200, 40),
            text: "カメラ", tag: BTN_CAMERA)
        self.view.addSubview(_btnCamera!)
        
        //フォト読み込みボタンの生成
        _btnRead = makeButton(CGRectMake(dx+60, 70, 200, 40),
            text: "フォト読み込み", tag: BTN_READ)
        self.view.addSubview(_btnRead!)
        
        //フォト書き込みボタンの生成
        _btnWrite = makeButton(CGRectMake(dx+60, 120, 200, 40),
            text: "フォト書き込み", tag: BTN_WRITE)
        self.view.addSubview(_btnWrite!)
        
        //イメージビューの生成
        _imageView = makeImageView(CGRectMake(dx+60, 190, 200, 200), image: nil)
        self.view.addSubview(_imageView!)
    }
    
    //ボタンクリック時に呼ばれる
    func onClick(sender: UIButton) {
        if sender.tag == BTN_CAMERA {
            openPicker(UIImagePickerControllerSourceType.Camera)
        } else if sender.tag == BTN_READ {
            openPicker(UIImagePickerControllerSourceType.PhotoLibrary)
        } else if sender.tag == BTN_WRITE {
            var image = _imageView!.image
            if image == nil {
                return
            }
            //イメージのフォトアルバムへの書き込み(6)
            UIImageWriteToSavedPhotosAlbum(image, self,
                "finishExport:didFinishSavingWithError:contextInfo:", nil)
        }
    }
    
    //テキストボタンの生成
    func makeButton(frame: CGRect, text: NSString, tag: Int) -> UIButton {
        let button = UIButton.buttonWithType(UIButtonType.System) as UIButton
        button.frame = frame
        button.setTitle(text, forState: UIControlState.Normal)
        button.tag = tag
        button.addTarget(self, action: "onClick:",
            forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }
    
    //イメージビューの生成
    func makeImageView(frame: CGRect, image: UIImage?) -> UIImageView {
        var imageView = UIImageView()
        imageView.frame = frame //領域
        imageView.image = image //イメージ
        imageView.contentMode = UIViewContentMode.ScaleAspectFit//コンテンツモード
        return imageView
    }
    
    //アラートの表示
    func showAlert(title: NSString?, text: NSString?) {
        let alert = UIAlertController(title: title, message: text,
            preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
//====================
//イメージピッカーのオープン
//====================
    //イメージピッカーのオープン
    func openPicker(sourceType: UIImagePickerControllerSourceType) {
        //カメラとフォトアルバムの利用可能チェック(1)
        if !UIImagePickerController.isSourceTypeAvailable(sourceType) {
            showAlert(nil, text: "利用できません")
            return
        }
    
        //イメージピッカーの生成(2)
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = self
    
        //ビューコントローラのビューを開く
        let model = UIDevice.currentDevice().model as NSString //モデル名
        if !model.containsString("iPad") {
            presentViewController(picker, animated: true, completion: nil)
        } else {
            let popoverCtl = UIPopoverController(contentViewController: picker)
            popoverCtl.presentPopoverFromRect(_btnCamera!.bounds, inView: _btnCamera!,
                permittedArrowDirections: UIPopoverArrowDirection.Any,
                animated: true)
        }
    }
    
    //フォト書き込み完了時に呼ばれる(6)
    func finishExport(image: UIImage,
        didFinishSavingWithError error: NSError!,
        contextInfo: AnyObject) {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            if error == nil {
                self.showAlert(nil, text: "フォト書き込み完了")
            } else {
                self.showAlert(nil, text: "フォト書き込み失敗")
            }
        }
    }
        
//====================
//UIImagePickerControllerDelegate
//====================
    //イメージピッカーのイメージ取得時に呼ばれる(4)
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        //イメージの指定
        let image = info[UIImagePickerControllerOriginalImage]
            as UIImage
        _imageView!.image = image
            
        //ビューコントローラのビューを閉じる
        picker.presentingViewController?
            .dismissViewControllerAnimated(true, completion: nil)
    }
    
    //イメージピッカーのキャンセル時に呼ばれる(4)
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        //ビューコントローラのビューを閉じる
        picker.presentingViewController?
            .dismissViewControllerAnimated(true, completion: nil)
    }
}
