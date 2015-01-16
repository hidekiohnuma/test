import SpriteKit
import UIKit

//ゲームシーン
class GameScene: SKScene {
    //シーン定数(2)
    let SCENE_TITLE = 0    //タイトル
    let SCENE_PLAY = 1     //プレイ
    let SCENE_GAMEOVER = 2 //ゲームオーバー
    
    //変数
    var _scene: Int = 0 //シーン(2)
    var _score: Int = 0 //スコア
    
    var _buildingTex = [SKTexture]() //ビルテクスチャ
    var _building: SKSpriteNode?     //ビル
    var _scoreLabel: SKLabelNode?    //スコアラベル
    var _meteoLayer: SKSpriteNode?   //隕石レイヤー
    var _shotLayer: SKSpriteNode?    //弾レイヤー
    var _ship: SKSpriteNode?         //宇宙船
    
    var _title: SKSpriteNode?    //タイトル
    var _gameover: SKSpriteNode? //ゲームオーバー
    var _gameoverDate: NSDate?   //ゲームオーバー時刻
    var _timer: NSTimer?         //タイマー
    
//====================
//UI
//====================

    //初期化時に呼ばれる
    override func didMoveToView(view: SKView) {
        //シーンの設定
        _scene = SCENE_TITLE;
    
        //画面サイズの取得
        let screenSize = UIScreen.mainScreen().bounds.size
        var scale = 360/screenSize.width
    
        //背景の生成
        var bg = SKSpriteNode(imageNamed: "bg.png")
        bg.position = CGPointMake(180, 320)
        self.addChild(bg)
        
        //ビルの生成
        _buildingTex.append(SKTexture(imageNamed: "building0.png")) //(3)
        _buildingTex.append(SKTexture(imageNamed: "building1.png")) //(3)
        _building = SKSpriteNode(color: UIColor.whiteColor(),
            size: CGSizeMake(360, 140))
        _building!.texture = _buildingTex[0] //(3)
        _building!.position = CGPointMake(180, 70)
        self.addChild(_building!)
    
        //隕石レイヤーの生成(4)
        _meteoLayer = SKSpriteNode(color: SKColor.clearColor(), size: CGSizeMake(360, 640))
        _meteoLayer!.anchorPoint = CGPointMake(0, 0)
        self.addChild(_meteoLayer!)
    
        //弾レイヤーの生成(4)
        _shotLayer = SKSpriteNode(color: SKColor.clearColor(), size: CGSizeMake(360, 640))
        _shotLayer!.anchorPoint = CGPointMake(0, 0)
        self.addChild(_shotLayer!)
    
        //宇宙船の生成
        _ship = SKSpriteNode(imageNamed: "ship.png")
        _ship!.position = CGPointMake(180, 180)
        self.addChild(_ship!)
    
        //スコアラベルの生成
        _scoreLabel = SKLabelNode(fontNamed: "ArialMT")
        _scoreLabel!.text = "SCORE:00000000"
        _scoreLabel!.fontSize = 20;
        _scoreLabel!.fontColor = SKColor.whiteColor()
        _scoreLabel!.position = CGPointMake(265,
            (640-screenSize.height*scale)/2+screenSize.height*scale-40)
        self.addChild(_scoreLabel!)
    
        //タイトルの生成
        _title = SKSpriteNode(imageNamed: "title.png");
        _title!.position = CGPointMake(180, 360);
    
        //ゲームオーバーの生成
        _gameover = SKSpriteNode(imageNamed: "gameover.png");
        _gameover!.position = CGPointMake(180, 360);
    
        //シーンをタイトルに遷移
        initScene(SCENE_TITLE)
    }
    
    //シーンの初期化(2)
    func initScene(scene: Int) {
        _scene=scene;
    
        //文字の削除
        _title?.removeFromParent()
        _gameover?.removeFromParent()
    
        //アクションの削除
        removeAllActions()
        for var i = 0; i < _shotLayer!.children.count; i++ {
            _shotLayer!.children[i].removeAllActions()
        }
        for var i = 0; i < _meteoLayer!.children.count; i++ {
            _meteoLayer!.children[i].removeAllActions()
        }
    
        //タイトル
        if _scene == SCENE_TITLE {
            //タイトルの表示
            self.addChild(_title!)
    
            //宇宙船の位置
            _ship!.position = CGPointMake(180, 180)
    
            //ビルの表示
            _building!.texture = _buildingTex[0] //(3)
    
            //スコアのリセット
            _scoreLabel!.text = "SCORE:00000000"
            _score = 0;
    
            //削除
            _meteoLayer?.removeAllChildren()
            _shotLayer?.removeAllChildren()
        }
        //プレイ
        else if _scene == SCENE_PLAY {
            //隕石追加処理の追加(5)
            _timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self,
                selector: "addMeteo", userInfo: nil, repeats: true)
        }
        //ゲームオーバー
        else if _scene == SCENE_GAMEOVER {
            //タイマーの停止
            if _timer != nil {
                _timer?.invalidate()
                _timer = nil
            }
            //ゲームオーバーの表示
            self.addChild(_gameover!);
        
            //ビルの表示
            _building!.texture = _buildingTex[1] //(3)
    
            //ゲームオーバー時間の指定
            _gameoverDate = NSDate()
        }
    }
    
    //タッチ時に呼ばれる
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        //タイトル
        if _scene == SCENE_TITLE {
            initScene(SCENE_PLAY)
        }
        //プレイ
        else if _scene == SCENE_PLAY {
            //弾の追加
            addShot()
        
            //宇宙船移動アクションの追加
            var pos = touches.allObjects[0].locationInNode(self)
            _ship?.runAction(SKAction.moveToX(pos.x, duration: 0.3))
        }
        //ゲームオーバー
        else if _scene == SCENE_GAMEOVER {
            //ゲームオーバー後1秒以上
            if _gameoverDate != nil &&
                NSDate().timeIntervalSinceDate(_gameoverDate!) > 1 {
                initScene(SCENE_TITLE)
            }
        }
    }
    
    //タッチ移動時に呼ばれる
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        //プレイ
        if _scene == SCENE_PLAY {
            //宇宙船移動アクションの追加
            var pos = touches.allObjects[0].locationInNode(self)
            _ship?.runAction(SKAction.moveToX(pos.x, duration: 0.1))
        }
    }
    
    //ノードのアクションの処理後に呼ばれる
    override func didEvaluateActions() {
        //プレイ
        if _scene == SCENE_PLAY {
            //弾の定期処理(7)
            for (var i = 0; i < _shotLayer!.children.count; i++) {
                var shot = _shotLayer!.children[i] as SKSpriteNode
                //画面上端まで移動した時
                if shot.position.y >= 640 {
                    shot.removeFromParent()
                }
                //弾と隕石が衝突した時
                else {
                    for var i = 0; i < _meteoLayer!.children.count; i++ {
                        var meteo = _meteoLayer!.children[i] as SKSpriteNode
                        if distance(shot.position.x, y0: shot.position.y,
                            x1: meteo.position.x, y1: meteo.position.y) < 20 {
                            shot.removeFromParent()
                            meteo.removeFromParent()
                            _score += 30
                            _scoreLabel!.text = String(format: "SCORE:%08d",_score)
                            addBom(meteo)
                        }
                    }
                }
            }
            //隕石の定期処理(7)
            for var i = 0; i < _meteoLayer!.children.count; i++ {
                var meteo = _meteoLayer!.children[i] as SKSpriteNode
                //画面下端まで移動した時
                if meteo.position.y <= 0 {
                    initScene(SCENE_GAMEOVER)
                }
            }
        }
    }
    
    //隕石の追加(6)
    func addMeteo() {
        let meteo = SKSpriteNode(imageNamed: "meteo.png")
        meteo.position = CGPointMake(CGFloat(20+rand(320)), 640)
        _meteoLayer?.addChild(meteo)
        meteo.runAction(SKAction.moveToY(0, duration: 7))
    }
    
    //弾の追加(6)
    func addShot() {
        let shot = SKSpriteNode(imageNamed: "shot.png")
        shot.position = CGPointMake(_ship!.position.x, _ship!.position.y)
        _shotLayer?.addChild(shot)
        shot.runAction(SKAction.moveToY(640, duration: 3))
    }
    
    //爆発の追加(6)
    func addBom(node: SKNode) {
        let bom = SKSpriteNode(imageNamed: "bom.png")
        bom.position = CGPointMake(node.position.x, node.position.y)
        _meteoLayer?.addChild(bom)
        bom.runAction(SKAction.sequence([
            SKAction.waitForDuration(0.1),
            SKAction.removeFromParent()
        ]))
    }
    
//====================
//ユーティリティ
//====================
    //乱数の取得
    func rand(num: UInt32) -> Int {
        return Int(arc4random()%num)
    }
    
    //2点の距離の計算(8)
    func distance(x0: CGFloat, y0: CGFloat,
        x1: CGFloat, y1: CGFloat) -> CGFloat {
        return sqrt((x0-x1)*(x0-x1)+(y0-y1)*(y0-y1))
    }
}
