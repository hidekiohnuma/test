import UIKit
import AVFoundation

//サウンドの再生
class ViewController: UIViewController {
    //定数
    let BTN_BGM_PLAY = 0 //BGM再生/停止
    let BTN_SE_PLAY = 1  //SE再生
    let BTN_VOL_UP = 2   //ボリュームアップ
    let BTN_VOL_DOWN = 3 //ボリュームダウン
    
    //変数
    var _player = [AVAudioPlayer]() //プレイヤー
    
    //ロード完了時に呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        let dx: CGFloat = (UIScreen.mainScreen().bounds.size.width-320)/2
        
        //BGM再生ボタンの生成
        let btnBGMStart = makeButton(CGRectMake(dx+60, 20, 200, 40),
            text: "BGM再生/停止", tag: BTN_BGM_PLAY)
        self.view.addSubview(btnBGMStart)
        
        //SE再生ボタンの生成
        let btnSEPlay = makeButton(CGRectMake(dx+60, 70, 200, 40),
            text: "SE再生", tag: BTN_SE_PLAY)
        self.view.addSubview(btnSEPlay)
        
        //ボリュームアップボタンの生成
        let btnVolUp = makeButton(CGRectMake(dx+60, 120, 200, 40),
            text: "ボリュームアップ", tag: BTN_VOL_UP)
        self.view.addSubview(btnVolUp)
        
        //ボリュームダウンボタンの生成
        let btnVolDown = makeButton(CGRectMake(dx+60, 170, 200, 40),
            text: "ボリュームダウン", tag: BTN_VOL_DOWN)
        self.view.addSubview(btnVolDown)
        
        //プレーヤーの生成
        _player.append(makeAudioPlayer("bgm.wav"))
        _player.append(makeAudioPlayer("se.wav"))
    }
    
    //ボタンクリック時に呼ばれる
    func onClick(sender: UIButton!) {
        if sender.tag == BTN_BGM_PLAY {
            //BGMの再生と停止(3)
            if !_player[0].playing {
                _player[0].numberOfLoops = 999
                _player[0].currentTime = 0
                _player[0].play()
            } else {
                _player[0].stop()
            }
        } else if sender.tag == BTN_SE_PLAY {
            //SEの再生(3)
            if _player[1].playing {
                _player[1].stop()
                _player[1].currentTime = 0
            } else {
                _player[1].play()
            }
        } else if sender.tag == BTN_VOL_UP {
            //ボリュームアップ(4)
            var volume = _player[0].volume + 0.2
            if volume > 1.0 {
                volume = 1.0
            }
            _player[0].volume = volume
            _player[1].volume = volume
        } else if sender.tag == BTN_VOL_DOWN {
            //ボリュームダウン(4)
            var volume = _player[0].volume - 0.2;
            if volume < 0.0 {
                volume=0.0
            }
            _player[0].volume = volume
            _player[1].volume = volume
        }
    }
    
    //テキストボタンの生成
    func makeButton(frame: CGRect, text: NSString, tag: Int) -> UIButton {
        let button = UIButton.buttonWithType(UIButtonType.System) as UIButton
        button.frame = frame
        button.setTitle(text, forState: UIControlState.Normal)
        button.tag = tag
        button.addTarget(self, action: "onClick:",
            forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }
    
    //オーディオプレーヤーの生成
    func makeAudioPlayer(res:String) -> AVAudioPlayer {
        //リソースURLの生成(1)
        let path = NSBundle.mainBundle().pathForResource(res, ofType: "")
        let url = NSURL.fileURLWithPath(path!)
    
        //オーディオプレーヤーの生成(2)
        return AVAudioPlayer(contentsOfURL: url, error: nil)
    }
}
