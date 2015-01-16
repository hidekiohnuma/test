import UIKit

//Interface BuilderによるUIデザイン
class ViewController: UIViewController {
    //Interface BuilderのUI部品と関連づけるプロパティ(1)
    @IBOutlet var _label: UILabel?

    //Interface BuilderのUI部品のイベントと関連づけるメソッド(2)
    @IBAction func onClick(sender: UIButton) {
        if sender.tag == 0 {
            _label!.text = "ボタンを押しました。"
        }
    }
}
