import UIKit
import SpriteKit

//ゲームシーン
class GameScene: SKScene { //(3)
    
    //初期化時に呼ばれる
    override func didMoveToView(view: SKView) {
        //シーンの設定(4)
        self.backgroundColor = SKColor.whiteColor() //背景色
        self.scaleMode = SKSceneScaleMode.AspectFit //スケールモード
        
        //ラベルの追加(5)
        let label = SKLabelNode(fontNamed: "ArialMT")
        label.text = "Hello SpriteKit!"
        label.fontSize = 20
        label.fontColor = SKColor.blackColor()
        label.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
        self.addChild(label)
    }
    
    //タッチ時に呼ばれる
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        //タッチ位置の取得
        let objects = touches.allObjects
        let touch = objects[0] as UITouch
        let location = touch.locationInNode(self)
        
        //スプライトの追加(6)
        let sprite = SKSpriteNode(imageNamed: "sample.png")
        sprite.position = location
        self.addChild(sprite)
        
        //スプライトのアクションの追加(7)
        var action = SKAction.rotateByAngle(CGFloat(M_PI), duration: 1)
        action = SKAction.repeatActionForever(action)
        sprite.runAction(action)
    }
    
    //フレーム描画時に呼ばれる
    override func update(currentTime: CFTimeInterval) {
    }
}
