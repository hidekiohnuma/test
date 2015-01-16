import UIKit

//バックグラウンドタスク
class ViewController: UIViewController {
    
    //ロード完了時に呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ラベルの生成
        let label = makeLabel(CGPointMake(0, 20),
            text: "BackgroundTaskEx", font: UIFont.systemFontOfSize(24))
        self.view.addSubview(label)
    }
    
    //ラベルの生成
    func makeLabel(pos: CGPoint, text: NSString, font: UIFont) -> UILabel {
        let label = UILabel()
        label.frame = CGRectMake(pos.x, pos.y, 9999, 9999)
        label.text = text
        label.font = font
        label.textAlignment = NSTextAlignment.Left
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }
}
