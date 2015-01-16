import UIKit

//アクションゲーム
class ActionView: UIView {
    //シーン定数(1)
    let S_TITLE = 0    //タイトル
    let S_PLAY = 1     //プレイ
    let S_GAMEOVER = 2 //ゲームオーバー
    
    //画面サイズ定数
    let SCREEN = UIScreen.mainScreen().bounds.size //画面サイズ
    let SCALE: CGFloat = 1 //画面スケール

    //システム
    var _init = 0             //初期化(1)
    var _scene = 0            //シーン(1)
    var _touchDown = false    //タッチダウン
    var _g = Graphics()       //グラフィックス
    var _images = [UIImage]() //イメージ郡
    var _message: String?     //メッセージ
    var _score = 0            //スコア
    
    //プレイヤー(3)
    var _playerY: CGFloat = 0 //Y座標
    var _jumpPow: CGFloat = 0 //ジャンプ力
    var _jumpAble = true      //ジャンプ可
    
    //ブロック(2)
    var _blockNum: Int = 16              //数
    var _blockDX: CGFloat = 0            //X相対位置
    var _blockH: [CGFloat] = [CGFloat]() //高さ
    
//====================
//UI
//====================
    //初期化
    required init(coder: NSCoder) {
        super.init(coder: coder)
    
        //画面サイズの調整
        if SCREEN.height >= 768 {
            SCALE = 2
            SCREEN.width /= 2
            SCREEN.height /= 2
        }
        
        //イメージの取得
        for var i = 0; i < 4; i++ {
            _images.append(UIImage(named: "act\(i).png")!)
        }
        
        //高さ
        for var i = 0; i < _blockNum; i++ {
            _blockH.append(0)
        }
        
        //タイマーの開始
        NSTimer.scheduledTimerWithTimeInterval(0.04,
            target: self, selector: "onTick:", userInfo: nil, repeats: true)
    }
    
    //定期処理
    func onTick(timer: NSTimer) {
        self.setNeedsDisplay()
    }
    
    
//====================
//描画
//====================
    //描画
    override func drawRect(rect: CGRect) {
        //コンテキストの指定
        _g.setContext(UIGraphicsGetCurrentContext())
        _g.setScale(SCALE, SCALE)
        
        //バッファのクリア
        _g.setColor(0, 0, 0)
        _g.fillRect(0, 0, SCREEN.width, SCREEN.height)
    
        //シーンの初期化
        if _init >= 0 {
            _scene = _init
            
            //タイトル
            if _scene == S_TITLE {
                _message = "Touch Start"
                _score   = 0
                _playerY = SCREEN.height-50
                _jumpPow = 0
                _jumpAble = true
                _blockDX = 0
                for var i = 0; i < _blockNum; i++ {_blockH[i] = 1}
            }
            //プレイ
            else if _scene == S_PLAY {
                _message = nil
                _touchDown = false
            }
            //ゲームオーバー
            else if _scene == S_GAMEOVER {
                _message = "Game Over"
            }
            _init = -1
        }
    
        //プレイ時の処理
        if _scene == S_PLAY {
            //スコア加算
            _score++
    
            //衝突判定
            if _playerY > SCREEN.height-_blockH[2]*50 {
                _init = S_GAMEOVER
                _jumpAble = false
            }
            //上移動
            else if _jumpPow >= 0 {
                _playerY -= _jumpPow*2
                _jumpPow--
            }
            //下移動(3)
            else {
                _playerY += 12
                _jumpAble = false
                if _blockH[2] != 0 &&
                    _playerY > SCREEN.height-_blockH[2]*50 {
                    _playerY = SCREEN.height-_blockH[2]*50
                    _jumpAble = true
                }
            }
            //ブロックのスクロール(2)
            _blockDX -= 10
            if _blockDX == -50 {
                _blockDX = 0
                
                //横方向の位置を戻し、高さを右隣のブロックと同じに
                for var i = 0; i < _blockNum-1; i++ {
                    _blockH[i] = _blockH[i+1]
                }
    
                //新規ブロックの高さの設定(3)
                var idx = rand(6)
                //1つ前が穴のときは2つ前の高さ
                if _blockH[_blockNum-2] == 0 {
                    _blockH[_blockNum-1] = _blockH[_blockNum-3]
                }
                //)1/6の確率で穴
                else if idx == 0 {
                    _blockH[_blockNum-1] = 0
                }
                //1/6の確率で1段上
                else if idx == 1 {
                    _blockH[_blockNum-1] = _blockH[_blockNum-2]+1
                    if _blockH[_blockNum-1] > 4 {_blockH[_blockNum-1] = 4}
                }
                //1/6の確率で1段下
                else if idx == 2 {
                    _blockH[_blockNum-1] = _blockH[_blockNum-2]-1
                    if _blockH[_blockNum-1] < 1 {_blockH[_blockNum-1] = 1}
                }
            }
    
            //ジャンプのコントロール(4)
            if _jumpAble {
                if _touchDown {
                    _jumpAble = false
                    _jumpPow = 14
                }
            } else {
                if !_touchDown {
                    _jumpPow = -10
                }
            }
        }
        //ゲームオーバー時の処理
        else if _scene == S_GAMEOVER {
            if _playerY < 700 {
                _playerY+=16
            }
        }
    
        //背景の描画
        _g.drawImage(_images[0], 0, 0, SCREEN.width, SCREEN.height)
        
        //プレイヤーの描画
        var idx = 3
        if _jumpAble {idx = 2+_score%2}
        _g.drawImage(_images[idx], 75, _playerY-50)
        
        //ブロックの描画
        for var i = 0; i < _blockNum; i++ {
            _g.drawImage(_images[1],
                _blockDX+CGFloat(i*50), SCREEN.height-_blockH[i]*50)
        }
        
        //スコアの描画
        _g.setColor(1, 1, 1)
        _g.setFont(UIFont.systemFontOfSize(24))
        _g.drawString("SCORE \(_score)", 10, 10)
        
        //メッセージの描画
        if _message != nil {
            _g.drawString(_message!,
                (SCREEN.width-_g.getStringSize(_message!).width)/2, 50)
        }
    }

//====================
//イベント
//====================
    //タッチ開始時に呼ばれる
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if _scene == S_TITLE {
            _init = S_PLAY
        } else if _scene == S_PLAY {
            _touchDown = true
        } else if _scene == S_GAMEOVER {
            if _playerY >= SCREEN.height+50 {
                _init = S_TITLE
            }
        }
    }
    
    //タッチ終了時に呼ばれる
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        _touchDown = false
    }
    
    //タッチキャンセル時に呼ばれる
    override func touchesCancelled(touches: NSSet, withEvent event: UIEvent) {
        _touchDown = false
    }
    
//====================
//ユーティリティ
//====================
    //乱数の取得
    func rand(num: UInt32) -> Int {
        return Int(arc4random()%num)
    }
}
