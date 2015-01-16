import UIKit
import MediaPlayer

//ムービーの再生
class ViewController: UIViewController {
    var _player: MPMoviePlayerController? //ムービープレイヤー

    //ロード完了時に呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        let dx: CGFloat = (UIScreen.mainScreen().bounds.size.width-320)/2
        
        //背景色の指定
        self.view.backgroundColor = UIColor.blackColor()
        
        //ムービープレイヤーの生成
        _player = makeMoviePlayer("sample.mp4")
        _player!.view.frame = CGRectMake(dx+0, 0, 320, 320)
        self.view.addSubview(_player!.view)
        
        //ムービーの再生(2)
        _player?.play()
        
        //ボリュームビューの生成(3)
        let volumeView = MPVolumeView()
        volumeView.frame = CGRectMake(dx+0, 420, 320, 40)
        self.view.addSubview(volumeView)
    }
    
    //ムービープレーヤーの生成
    func makeMoviePlayer(res: NSString) -> MPMoviePlayerController {
        //リソースURLの生成
        let path = NSBundle.mainBundle().pathForResource(res, ofType: "");
        let url = NSURL(fileURLWithPath: path!)
    
        //ムービープレイヤーの生成(1)
        let player = MPMoviePlayerController(contentURL: url)
        player.scalingMode = MPMovieScalingMode.AspectFit
        player.controlStyle = MPMovieControlStyle.Embedded
        return player
    }
}
