import UIKit

//メイン画面のビューコントローラ
class ViewController: UIViewController {

    //ビュー遷移時に呼ばれる(1)
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("ViewController.prepareForSegue>\(segue.identifier)");
    }
    
    //ビュー戻り時に呼ばれる
    @IBAction func firstViewReturnActionForSegue(segue: UIStoryboardSegue) {
        println("ViewController.firstViewReturnActionForSegue>")
    }
}
