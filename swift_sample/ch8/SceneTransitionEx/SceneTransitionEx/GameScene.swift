import UIKit
import SpriteKit

//ゲームシーン
class GameScene: SKScene {
    var _type = 0//トランジション種別
    
    //初期化時に呼ばれる
    override func didMoveToView(view: SKView) {
        //シーンの設定
        self.backgroundColor = SKColor.whiteColor()
        self.scaleMode = SKSceneScaleMode.AspectFit
    }
    
    //トランジション種別の指定(1)
    func setTransitionType(type: Int) {
        _type = type
        
        //スプライトの追加
        let texture = SKTexture(imageNamed: "sample\(_type%2).png")
        let sprite = SKSpriteNode(texture: texture)
        sprite.position = CGPointMake(
            self.frame.size.width/2, self.frame.size.height/2)
        sprite.size = CGSizeMake(320, 320)
        self.addChild(sprite)
    }
    
    //タッチ時に呼ばれる
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        //シーンの生成
        let scene = GameScene(size: self.frame.size)
        scene.setTransitionType((_type+1)%12) //(1)
        
        //トランジションオブジェクトの生成(2)
        var trans: SKTransition? = nil
        switch _type {
        case 1:
            trans = SKTransition.doorsCloseHorizontalWithDuration(0.5)
        case 2:
            trans = SKTransition.doorsCloseVerticalWithDuration(0.5)
        case 3:
            trans = SKTransition.doorsOpenHorizontalWithDuration(0.5)
        case 4:
            trans = SKTransition.doorsOpenVerticalWithDuration(0.5)
        case 5:
            trans = SKTransition.doorwayWithDuration(0.5)
        case 6:
            trans = SKTransition.fadeWithColor(SKColor.whiteColor(),
                duration: 0.5)
        case 7:
            trans = SKTransition.fadeWithDuration(0.5)
        case 8:
            trans = SKTransition.flipHorizontalWithDuration(0.5)
        case 9:
            trans = SKTransition.flipVerticalWithDuration(0.5)
        case 10:
            trans = SKTransition.moveInWithDirection(SKTransitionDirection.Up,
                duration: 0.5)
        case 11:
            trans = SKTransition.pushWithDirection(SKTransitionDirection.Up,
                duration: 0.5)
        default:
            trans = SKTransition.revealWithDirection(SKTransitionDirection.Up,
                duration: 0.5)
        }
        
        //トランジション付きのシーン追加(3)
        self.view!.presentScene(scene, transition: trans)
    }
    
    //フレーム描画時に呼ばれる
    override func update(currentTime: CFTimeInterval) {
    }
}
