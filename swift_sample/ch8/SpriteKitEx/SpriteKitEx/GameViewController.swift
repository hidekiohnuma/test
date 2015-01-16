import UIKit
import SpriteKit

//ゲームビューコントローラ
class GameViewController: UIViewController {
    
    //ロード完了時に呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SpriteKitのビューの設定(1)
        let skView = self.view as SKView
        skView.showsFPS = true       //FPSの表示
        skView.showsNodeCount = true //ノード数の表示
        
        //シーンの追加(2)
        let scene = GameScene(size: skView.frame.size)
        skView.presentScene(scene)
    }
}
