import UIKit

//パズルゲーム
class ViewController: UIViewController {
    //定数
    let BTN_START = 0 //スタート
    let SCREEN = UIScreen.mainScreen().bounds.size //画面サイズ
    
    //変数
    var _gameView: UIView?       //ゲームビュー
    var _titleLabel: UILabel?    //タイトルラベル
    var _piece = [UIImageView]() //ピース画像(2)
    var _data = [Int]()          //ピース配置情報(2)
    var _shuffle: Int = 0        //シャッフル
    var _startButton: UIButton?  //スタートボタン
    
    
//====================
//UI
//====================
    //ロード完了時に呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ゲーム画面のXY座標とスケールの指定(1)
        let vx: CGFloat = (SCREEN.width-360)/2
        let vy: CGFloat = (SCREEN.height-640)/2
        let scale = SCREEN.width/360
        _gameView = UIView()
        _gameView!.frame = CGRectMake(vx, vy, 360, 640)
        _gameView!.transform = CGAffineTransformMakeScale(scale, scale)
        self.view.addSubview(_gameView!)
        
        //背景の生成
        let bg = makeImageView(CGRectMake(0, 0, 360, 640),
            image: UIImage(named: "bg.png")!)
        _gameView?.addSubview(bg)
        
        //絵の背景の生成
        let picturebg = makeImageView(CGRectMake(29, 179, 302, 302),
            image: UIImage(named: "picturebg.png")!)
        _gameView?.addSubview(picturebg)
        
        //タイトルラベルの生成
        _titleLabel = makeLabel(CGRectMake(0, 90, 360, 70),
            text: "Moon Puzzle", font: UIFont.systemFontOfSize(48))
        _gameView?.addSubview(_titleLabel!)
        
        //絵のビットマップの取得
        let picture = UIImage(named: "picture.png")!
        let piece = UIImage(named: "piece.png")!
        for var i = 0; i < 16; i++ {
            _piece.append(makePieceImageView(CGRectMake(
                CGFloat(30+(i%4)*75),
                CGFloat(180+Int(i/4)*75),
                75, 75),
                index: i, picture: picture, piece: piece))
            _data.append(i)
            _gameView?.addSubview(_piece[i])
        }
        
        //スタートボタンの生成
        _startButton = makeButton(CGRectMake(124, 455, 114, 114),
            image: UIImage(named: "start.png")!, tag: BTN_START)
        _gameView?.addSubview(_startButton!)
    }
    
    //ラベルの生成
    func makeLabel(frame: CGRect, text: NSString, font: UIFont) -> UILabel {
        var label = UILabel()
        label.frame = frame
        label.text = text
        label.font = font
        label.textColor = UIColor.whiteColor()
        label.textAlignment = NSTextAlignment.Center
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.numberOfLines = 0
        return label
    }
    
    //イメージビューの生成
    func makeImageView(frame: CGRect, image: UIImage) -> UIImageView {
        var imageView = UIImageView()
        imageView.frame = frame
        imageView.image = image
        return imageView
    }
    
    //ピースイメージビューの生成
    func makePieceImageView(frame: CGRect, index: Int,
        picture: UIImage, piece: UIImage) -> UIImageView {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        picture.drawInRect(
            CGRectMake(CGFloat(-75*(index%4)),
            CGFloat(-75*Int(index/4)),
            300, 300))
        piece.drawInRect(CGRectMake(0, 0, 75, 75))
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return makeImageView(frame, image: image)
    }
    
    //イメージボタンの生成
    func makeButton(frame: CGRect, image: UIImage, tag: Int) -> UIButton {
        let button = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        button.frame = frame
        button.setImage(image, forState: UIControlState.Normal)
        button.tag = tag
        button.addTarget(self, action: "onClick:",
            forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }
    
//====================
//タッチイベント
//====================
    //ボタンクリック時に呼ばれる
    func onClick(sender: UIButton!) {
        if sender.tag == BTN_START {
            //シャッフルの実行(8)
            _shuffle = 20
            while _shuffle > 0 {
                if movePiece(rand(4), ty: rand(4)) {_shuffle--}
            }
            for var i = 0; i < 16; i++ {
                var dx: CGFloat = 30+75*CGFloat(i%4)
                var dy: CGFloat = 180+75*CGFloat(i/4)
                _piece[_data[i]].frame =
                    CGRectMake(dx, dy, 75, 75)
            }
    
            //ゲーム開始
            _titleLabel!.text = "Moon Puzzle"
            _piece[15].alpha = 0
            _startButton!.alpha = 0
        }
    }
    
    //タッチ開始時に呼ばれる
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if _startButton!.alpha != 0 {
            return
        }
        //タッチ位置からピースの列番号と行番号を求める(3)
        var pos = touches.allObjects[0].locationInView(_gameView)
        if 30 < pos.x && pos.x < 330 && 180 < pos.y && pos.y < 480 {
            let tx = Int((pos.x-30)/75)
            let ty = Int((pos.y-180)/75)
            movePiece(tx, ty: ty)
        }
    }
    
    //ピースの移動
    func movePiece(tx: Int, ty: Int) -> Bool {
        //空きマスの行番号と列番号を求める(4)
        var fx = 0
        var fy = 0
        for var i = 0; i < 16; i++ {
            if _data[i] == 15 {
                fx = i%4
                fy = Int(i/4)
                break
            }
        }
        if (fx == tx && fy == ty) || (fx != tx && fy != ty) {
            return false
        }
    
        //ピースを上にスライド(5)
        if fx == tx && fy < ty {
            for var i = fy; i < ty; i++ {
                _data[fx+i*4] = _data[fx+i*4+4]
            }
            _data[tx+ty*4] = 15
        }
        //ピースを下にスライド(5)
        else if fx == tx && fy > ty {
            for var i = fy; i > ty; i-- {
                _data[fx+i*4] = _data[fx+i*4-4]
            }
            _data[tx+ty*4] = 15
        }
        //ピースを左にスライド(5)
        else if fy == ty && fx < tx {
            for var i = fx; i < tx; i++ {
                _data[i+fy*4] = _data[i+fy*4+1]
            }
            _data[tx+ty*4] = 15
        }
        //ピースを右にスライド(5)
        else if fy == ty && fx > tx {
            for var i = fx; i > tx; i-- {
                _data[i+fy*4]=_data[i+fy*4-1]
            }
            _data[tx+ty*4] = 15
        }
        
        //シャッフル時はピースの移動アニメとクリアチェックは行わない
        if _shuffle > 0 {
            return true
        }
    
        //ピースの移動アニメとクリアチェック(6)
        var clearCheck = 0
        for var i = 0; i < 16; i++ {
            var dx: CGFloat = 30+75*CGFloat(i%4)
            var dy: CGFloat = 180+75*CGFloat(i/4)
    
            //ピースの移動アニメ
            if _data[i] != 15 {
                UIView.beginAnimations("anime0", context: nil)
                UIView.setAnimationDuration(0.3)
                _piece[_data[i]].frame = CGRectMake(dx, dy, 75, 75)
                UIView.commitAnimations()
            } else {
                _piece[_data[i]].frame = CGRectMake(dx, dy, 75, 75)
            }
    
            //クリアチェック
            if _data[i] == i {clearCheck++}
        }
    
        //ゲームのクリア判定(7)
        if clearCheck == 16 {
            _titleLabel!.text = "Clear!"
            _startButton!.alpha = 100
    
            //ピースの出現アニメ
            UIView.beginAnimations("anime1", context: nil)
            UIView.setAnimationDuration(0.6)
            _piece[15].alpha = 100
            UIView.commitAnimations()
        }
        return true
    }
    
//====================
//ユーティリティ
//====================
    //乱数の取得
    func rand(num: UInt32) -> Int {
        return Int(arc4random()%num)
    }
}
