import UIKit

//ラベルとイメージビュー
class ViewController: UIViewController {
    
    //ロード完了時に呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()

        //ラベルの生成(1)
        let label = makeLabel(CGPointMake(0, 20),
            text: "これはテストです", font: UIFont.systemFontOfSize(24))
        
        //コンポーネントの配置(3)
        self.view.addSubview(label)
        
        //イメージビューの生成(4)
        let imageView = makeImageView(CGRectMake(0, 70, 80, 80),
            image: UIImage(named: "sample.png")!)
        
        //コンポーネントの配置
        self.view.addSubview(imageView)
    }
    
    //ラベルの生成(1)
    func makeLabel(pos: CGPoint, text: NSString, font: UIFont) -> UILabel {
        let label = UILabel()
        label.frame = CGRectMake(pos.x, pos.y, 9999, 9999)  //領域
        label.text = text                                   //テキスト
        label.font = font                                   //フォント
        label.textAlignment = NSTextAlignment.Left          //配置
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping//改行
        label.numberOfLines = 0                             //行数
        label.sizeToFit() //ラベルとテキストの幅と高さをあわせる(2)
        return label
    }
    
    //イメージビューの生成(4)
    func makeImageView(frame: CGRect, image: UIImage) -> UIImageView {
        let imageView = UIImageView()
        imageView.frame = frame//領域
        imageView.image = image//イメージ
        return imageView
    }
}
