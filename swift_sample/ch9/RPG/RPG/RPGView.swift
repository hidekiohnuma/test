import UIKit

//RPG
class RPGView: UIView {
    //シーン定数(1)
    let S_START = 0     //スタート
    let S_MAP = 1       //マップ
    let S_APPEAR = 2    //出現
    let S_COMMAND = 3   //コマンド
    let S_ATTACK0 = 4   //攻撃0
    let S_ATTACK1 = 5   //攻撃1
    let S_DEFENCE0 = 6  //防御0
    let S_DEFENCE1 = 7  //防御1
    let S_ESCAPE0 = 8   //逃走0
    let S_ESCAPE1 = 9   //逃走1
    let S_WIN = 10      //勝利
    let S_GAMEOVER = 11 //ゲームオーバー
    let S_LEVELUP = 12  //レベルアップ
    let S_ENDING = 13   //エンディング
    
    //キー定数
    let KEY_NONE = -1  //なし
    let KEY_LEFT = 0   //左
    let KEY_RIGHT = 1  //右
    let KEY_UP = 2     //上
    let KEY_DOWN = 3   //下
    let KEY_1 = 4      //１
    let KEY_2 = 5      //２
    let KEY_SELECT = 6 //選択
    
    //マップ定数(2)
    let MAP = [
        [3, 3, 3, 3, 3, 3, 3, 3, 3, 3],
        [3, 1, 0, 0, 0, 0, 3, 0, 0, 3],
        [3, 0, 0, 0, 0, 0, 3, 3, 0, 3],
        [3, 0, 3, 3, 3, 3, 3, 3, 0, 3],
        [3, 0, 0, 3, 0, 0, 0, 3, 0, 3],
        [3, 3, 0, 3, 0, 3, 3, 3, 0, 3],
        [3, 0, 0, 3, 0, 0, 0, 0, 0, 3],
        [3, 0, 3, 3, 0, 3, 0, 3, 3, 3],
        [3, 0, 0, 0, 0, 3, 0, 0, 2, 3],
        [3, 3, 3, 3, 3, 3, 3, 3, 3, 3]]
    
    //勇者定数(3)
    let YU_MAXHP = [0, 30, 50, 70] //最大体力
    let YU_ATTACK = [0, 5, 10, 30] //攻撃力
    let YU_DEFENCE = [0, 0, 5, 10] //守備力
    let YU_EXP = [0, 0, 3, 6]      //必要経験値
    
    //敵定数(4)
    let EN_NAME = ["ザコ", "ボス"] //名前
    let EN_MAXHP = [10, 50]  //最大体力
    let EN_ATTACK = [10, 26] //攻撃力
    let EN_DEFENCE = [0, 16] //守備力
    let EN_EXP = [1, 99]     //取得経験値
    
    //画面サイズ定数
    let SCREEN = UIScreen.mainScreen().bounds.size //画面サイズ
    let SCALE: CGFloat = 1 //画面スケール
    
    //システム
    var _init = 0   //初期化(1)
    var _scene = 0  //シーン(1)
    var _key = 0    //キー
    var _tick = 0   //時間経過
    var _damage = 0 //ダメージ
    var _g = Graphics()       //グラフィックス
    var _images = [UIImage]() //イメージ郡
    
    //勇者パラメータ(3)
    var _yuX = 0   //X座標
    var _yuY = 0   //Y座標
    var _yuLV = 0  //レベル
    var _yuHP = 0  //体力
    var _yuEXP = 0 //経験値
    
    //敵パラメータ(4)
    var _enType = 0 //種類
    var _enHP = 0   //体力
    
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
        for var i = 0; i < 7; i++ {
            _images.append(UIImage(named: "rpg\(i).png")!)
        }
        
        //タイマーの開始
        NSTimer.scheduledTimerWithTimeInterval(0.1,
            target: self, selector: "onTick:", userInfo: nil, repeats: true)
    }
    
    //定期処理
    func onTick(timer: NSTimer) {
        self.setNeedsDisplay()
    }
    
//====================
//描画
//====================
    //ステータスの描画
    func drawStatus() {
        _g.setColor(1, 1, 1)
        _g.fillRect((SCREEN.width-504)/2, 8, 504, 54)
        if _yuHP != 0 {
            _g.setColor(0, 0, 0)
        } else {
            _g.setColor(1, 0, 0)
        }
        _g.fillRect((SCREEN.width-500)/2, 10, 500, 50)
        _g.setColor(1, 1, 1)
        _g.setFont(UIFont.systemFontOfSize(32))
        _g.drawString("勇者 LV\(_yuLV) HP\(_yuHP)/\(YU_MAXHP[_yuLV])",
            (SCREEN.width-500)/2+50, 16)
    }
    
    //戦闘画面の描画
    func drawBattle(message: String, visible: Bool)  {
        if _yuHP != 0 {
            _g.setColor(0, 0, 0)
        } else {
            _g.setColor(1, 0, 0)
        }
        _g.fillRect(0, 0, SCREEN.width, SCREEN.height)
        drawStatus()
        if visible {
            let image = _images[5+_enType]
            _g.drawImage(image,
                (SCREEN.width-image.size.width)/2,
                SCREEN.height-100-image.size.height)
        }
        _g.setColor(1, 1, 1)
        _g.fillRect((SCREEN.width-504)/2, SCREEN.height-122, 504, 104)
        if _yuHP != 0 {
            _g.setColor(0, 0, 0)
        } else {
            _g.setColor(1, 0, 0)
        }
        _g.fillRect((SCREEN.width-500)/2, SCREEN.height-120, 500, 100)
        _g.setColor(1, 1, 1)
        _g.setFont(UIFont.systemFontOfSize(32))
        _g.drawString(message, (SCREEN.width-500)/2+50, SCREEN.height-90)
    }
    
    //戦闘画面の描画
    func drawBattle(message: String) {
        self.drawBattle(message, visible: _enHP >= 0)
    }
    
    //描画
    override func drawRect(rect: CGRect) {
        var flag = false
        //コンテキストの指定
        _g.setContext(UIGraphicsGetCurrentContext())
        _g.setScale(SCALE, SCALE)
    
        //バッファのクリア
        _g.setColor(0, 0, 0)
        _g.fillRect(0, 0, SCREEN.width, SCREEN.height)
    
        //シーンの初期化
        if _init >= 0 {
            _scene = _init
            //スタート
            if _scene == S_START {
                _scene = S_MAP
                _yuX = 1      //X座標
                _yuY = 2      //Y座標
                _yuLV = 1     //レベル
                _yuHP = 30    //体力
                _yuEXP = 1000 //経験値
            }
            
           //攻撃1
           if _scene == S_ATTACK1 {
               //ダメージの計算(6)
               _damage = YU_ATTACK[_yuLV]-EN_DEFENCE[_enType]+rand(10)
               if _damage <= 1 {_damage = 1}
               if _damage >= 99 {_damage = 99}
           }
           //防御1
           if _scene == S_DEFENCE1 {
               //防御の計算(7)
               _damage = EN_ATTACK[_enType]-YU_DEFENCE[_yuLV]+rand(10)
                if _damage <= 1 {_damage = 1}
                if _damage >= 99 {_damage = 99}
           }
           _init = -1
           _tick = 0
           _key = KEY_NONE
       }
    
        //マップ
        if _scene == S_MAP {
            //移動
            if _key == KEY_UP {
                if MAP[_yuY-1][_yuX] <= 2 {_yuY--; flag = true}
            } else if _key == KEY_DOWN {
                if MAP[_yuY+1][_yuX] <= 2 {_yuY++; flag = true}
            } else if _key == KEY_LEFT {
                if MAP[_yuY][_yuX-1] <= 2 {_yuX--; flag = true}
            } else if _key==KEY_RIGHT {
                if MAP[_yuY][_yuX+1] <= 2 {_yuX++; flag = true}
            }
    
            //敵出現の計算(5)
            if flag {
                if MAP[_yuY][_yuX] == 0 && rand(10) == 0 {
                    _enType = 0; _init = S_APPEAR}
                if MAP[_yuY][_yuX] == 1 {_yuHP = YU_MAXHP[_yuLV]}
                if MAP[_yuY][_yuX] == 2 {_enType = 1; _init = S_APPEAR}
            }
    
            //描画
            for (var j = -3; j <= 3; j++) {
                for (var i = -5; i <= 5; i++) {
                    var idx = 3
                    if 0 <= _yuX+i && _yuX+i < 10 &&
                        0 <= _yuY+j && _yuY+j < 10 {
                        idx = MAP[_yuY+j][_yuX+i]
                    }
                    _g.drawImage(_images[idx],
                        SCREEN.width/2-40+80*CGFloat(i),
                        SCREEN.height/2-40+80*CGFloat(j))
                }
            }
            _g.drawImage(_images[4], SCREEN.width/2-40, SCREEN.height/2-40)
            drawStatus()
        }
        //出現
        else if _scene == S_APPEAR {
            _enHP = EN_MAXHP[_enType]
    
            //フラッシュ
            if _tick < 6 {
                if _tick%2 == 0 {
                    _g.setColor(0, 0, 0)
                } else {
                    _g.setColor(1, 1, 1)
                }
                _g.fillRect(0, 0, SCREEN.width, SCREEN.height)
            }
            //選択
            else {
                drawBattle("\(EN_NAME[_enType])があらわれた")
                if _key == KEY_SELECT {_init = S_COMMAND}
            }
        }
    
        //コマンド
        else if _scene == S_COMMAND {
            drawBattle("　　1.攻撃　　2.逃げる")
            if _key == KEY_1 {_init = S_ATTACK0}
            if _key == KEY_2 {_init = S_ESCAPE0}
        }
        //攻撃0
        else if _scene == S_ATTACK0 {
            drawBattle("勇者の攻撃")
            if _key == KEY_SELECT {_init = S_ATTACK1}
        }
        //攻撃1
        else if _scene == S_ATTACK1 {
            //フラッシュ
            if _tick < 10 {
                drawBattle("勇者の攻撃", visible: _tick%2 == 0)
            }
            //ダメージの表示
            else {
                drawBattle("\(_damage)ダメージ与えた！")
                if _key==KEY_SELECT {
                    //体力の計算
                    _enHP -= _damage
                    if _enHP <= 0 {_enHP = 0}
    
                    //遷移
                    _init = _enHP == 0 ? S_WIN : S_DEFENCE0
                }
            }
        }
        //勝利
        else if _scene == S_WIN {
            drawBattle("\(EN_NAME[_enType])を倒した")
            if _key == KEY_SELECT {
                //経験値の計算
                _yuEXP += EN_EXP[_enType]
    
                //遷移
                if _yuLV < 3 && YU_EXP[_yuLV+1] <= _yuEXP {
                    _yuLV++
                    _init = S_LEVELUP
                } else if _enType == 1 {
                    _init = S_ENDING
                } else {
                    _init = S_MAP
                }
            }
        }
        //レベルアップ
        else if _scene == S_LEVELUP {
            drawBattle("レベルアップした")
            if _key == KEY_SELECT {
                //遷移
                _init = _enType == 1 ? S_ENDING : S_MAP
            }
        }
        //エンディング
        else if _scene == S_ENDING {
            _g.setColor(0, 0, 0)
            _g.fillRect(0, 0, SCREEN.width, SCREEN.height)
            _g.setColor(1, 1, 1)
            _g.setFont(UIFont.systemFontOfSize(32))
            let str = "Fin."
            _g.drawString(str,
                (SCREEN.width-_g.getStringSize(str).width)/2, 200)
            if _key == KEY_SELECT {_init = S_START}
        }
        //防御0
        else if _scene == S_DEFENCE0 {
            drawBattle("\(EN_NAME[_enType])の攻撃")
            if _key == KEY_SELECT {_init = S_DEFENCE1}
        }
        //防御1
        else if _scene == S_DEFENCE1 {
            //フラッシュ
            if _tick < 10 {
                if _tick%2 == 0 {
                    _g.setColor(1, 1, 1)
                    _g.fillRect(0, 0, SCREEN.width, SCREEN.height)
                } else {
                    drawBattle("\(EN_NAME[_enType])の攻撃")
                }
            }
            //ダメージの表示
            else {
                drawBattle("\(_damage)ダメージ受けた！")
                if _key == KEY_SELECT {
                    //体力の計算
                    _yuHP -= _damage
                    if _yuHP <= 0 {_yuHP = 0}
    
                    //遷移
                    _init = _yuHP == 0 ? S_GAMEOVER : S_COMMAND
                }
            }
        }
        //ゲームオーバー
        else if _scene == S_GAMEOVER {
            drawBattle("勇者は力尽きた")
            if _key == KEY_SELECT {_init = S_START}
        }
        //逃走0
        else if _scene == S_ESCAPE0 {
            drawBattle("勇者は逃げ出した")
            if _key == KEY_SELECT {
                //逃げるの計算(8)
                _init = _enType == 1 || rand(100) <= 10 ? S_ESCAPE1 : S_MAP
            }
        }
        //逃走1
        else if _scene == S_ESCAPE1 {
            drawBattle("\(EN_NAME[_enType])は回り込んだ")
            if _key == KEY_SELECT {_init = S_DEFENCE0}
        }
        
        //時間経過
        _key = -999
       _tick++
        if _tick > 999 {_tick = 100}
    }
    
    
//====================
//イベント
//====================
    //タッチ開始時に呼ばれる
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let objects = touches.allObjects
        var pos: CGPoint = objects[0].locationInView(self)
        pos.x /= SCALE
        pos.y /= SCALE
        if _scene == S_MAP {
            let dx = pos.x-SCREEN.width/2
            let dy = pos.y-SCREEN.height/2
            if abs(dx) > abs(dy) {
                _key = dx < 0 ? KEY_LEFT : KEY_RIGHT
            } else {
                _key = dy < 0 ? KEY_UP : KEY_DOWN
            }
        } else if _scene == S_COMMAND {
            if SCREEN.height-90 < pos.y && pos.y < SCREEN.height-60 {
                _key = pos.x < SCREEN.width/2 ? KEY_1 : KEY_2
            }
        } else {
            _key=KEY_SELECT
        }
    }
    
    
//====================
//ユーティリティ
//====================
    //乱数の取得
    func rand(num: UInt32) -> Int {
        return Int(arc4random()%num)
    }
}
