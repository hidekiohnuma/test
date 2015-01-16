import UIKit
import SpriteKit

//ゲームシーン
class GameScene: SKScene {
    
    //初期化時に呼ばれる
    override func didMoveToView(view: SKView) {
        //シーンの設定
        self.backgroundColor = SKColor.blackColor() //背景色
        self.scaleMode = SKSceneScaleMode.AspectFit //スケールモード
        
        //バーの生成
        makeBar()
        
        //ボール追加アクションの追加(3)
        NSTimer.scheduledTimerWithTimeInterval(0.1, target: self,
            selector: "addBall", userInfo: nil, repeats: true)
    }
    
    //物理シミュレーションの処理後に呼ばれる
    override func didSimulatePhysics() {
        //ボールが画面下に落ちたら削除(4)
        self.enumerateChildNodesWithName("ball", usingBlock: {
            (node: SKNode!, stop: UnsafeMutablePointer<ObjCBool>) in
            if node.position.y < 0 {
                node.removeFromParent()
            }
        })
    }
    
    //フレーム描画時に呼ばれる
    override func update(currentTime: CFTimeInterval) {
    }

    //ボールの追加
    func addBall() {
        //スプライトの追加
        var ball = SKSpriteNode(imageNamed: "ball.png")
        var hoge:CGFloat = CGFloat(rand(Int(self.size.width)))
        ball.position = CGPoint(
            x: CGFloat(rand(Int(self.size.width))),
            y: CGFloat(rand(Int(self.size.height))))
        ball.name = "ball"
        self.addChild(ball)
    
        //衝突判定の指定(1)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        ball.physicsBody?.dynamic = true
    }
    
    //バーの追加
    func makeBar() {
        //スプライトの追加
        let bar = SKSpriteNode(imageNamed: "bar.png")
        bar.position = CGPointMake(60, 100)
        self.addChild(bar)
    
        //左右移動アクションの追加(2)
        let action = SKAction.sequence([
            SKAction.waitForDuration(1.0),
            SKAction.moveByX(self.size.width-120, y: 0.0, duration: 1.0),
            SKAction.waitForDuration(1.0),
            SKAction.moveByX(-(self.size.width-120), y: 0, duration: 1.0)
        ])
        bar.runAction(SKAction.repeatActionForever(action))
        
        //衝突判定の指定(1)
        bar.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(120, 12))
        bar.physicsBody?.dynamic = false
    }
    
    //乱数の取得
    func rand(num: Int) -> Int {
        return Int(arc4random())%num
    }
}
