import UIKit
import SpriteKit

//ゲームビューコントローラ
class GameViewController: UIViewController {
    
    //ロード完了時に呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //スプライトキットのビューの設定
        let skView = self.view as SKView
        skView.showsFPS = false       //FPSの表示
        skView.showsNodeCount = false //ノード数の表示
        
        //シーンの追加(1)
        let scene = GameScene(size: CGSizeMake(360, 640))
        scene.scaleMode = SKSceneScaleMode.AspectFill
        skView.presentScene(scene)
    }
}
