import UIKit

//ピッカー
class ViewController: UIViewController,
    UIPickerViewDelegate, UIPickerViewDataSource {
    //定数
    let BTN_SHOW = 0 //表示
    
    //変数
    var _pickerView: UIPickerView? //ピッカー
    var _items = [String]()        //要素群
    var _selectIdx: Int = 0        //選択インデックス
    
//====================
//UI
//====================
    //ロード完了時に呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        let dx: CGFloat = (UIScreen.mainScreen().bounds.size.width-320)/2
        
        //フォントファミリー名の取得(1)
        var familyNames = UIFont.familyNames() as [String]
        
        //配列のソート(2)
        sort(&familyNames) {$0 < $1}
        
        for var i = 0; i < familyNames.count; i++ {
            //フォント名の取得(3)
            var fontNames = UIFont.fontNamesForFamilyName(
                familyNames[i]) as [String]
            
            //配列のソート(2)
            sort(&fontNames) {$0 < $1}
            
            //追加
            for var j = 0; j < fontNames.count; j++ {
                _items.append(fontNames[j] as String)
            }
        }
        
        //ピッカービューの生成(4)
        _pickerView = makePickerView(CGRectMake(dx+0, 20, 320, 200))
        self.view.addSubview(_pickerView!)
        _selectIdx = 0
        
        //ボタンの生成
        var btnShow: UIButton = makeButton(CGRectMake(dx+110, 230, 100, 40),
            text: "表示", tag: BTN_SHOW)
        self.view.addSubview(btnShow)
    }
    
    //ボタンクリック時に呼ばれる
    func onClick(sender: UIButton) {
        if sender.tag == BTN_SHOW {
            let name = _items[_selectIdx]
            showAlert(nil, text: "ピッカーの選択\n\(name)")
        }
    }
    
    //アラートの表示
    func showAlert(title: NSString?, text: NSString?) {
        let alert = UIAlertController(title: title, message: text,
            preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
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
    
    //ピッカーの生成
    func makePickerView(frame: CGRect) -> UIPickerView {
        let pickerView = UIPickerView()
        pickerView.frame = frame
        pickerView.showsSelectionIndicator = true
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }

//====================
//UIPickerViewDelegate
//====================
    //行の高さの取得(5)
    func pickerView(pickerView: UIPickerView,
        rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    //行のセルの取得(5)
    func pickerView(pickerView: UIPickerView, viewForRow row: Int,
        forComponent component: Int, reusingView view: UIView) -> UIView {
        //セルの生成
        var cell = UIView(frame: CGRectMake(0, 0, 280, 30))
    
        //セルにラベルを追加
        var fontName = _items[row]
        var label = UILabel()
        label.frame = CGRectMake(0, 0, 280, 40)
        label.font = UIFont(name: fontName, size: 18)
        label.backgroundColor = UIColor.clearColor()
        label.text = fontName
        cell.addSubview(label)
        return cell
    }
    
    //ピッカー選択時に呼ばれる(5)
    func pickerView(pickerView: UIPickerView,
        didSelectRow row: Int, inComponent component: Int) {
        _selectIdx = row
    }
    
//====================
//UIPickerViewDataSource
//====================
    //行数の取得(6)
    func pickerView(pickerView: UIPickerView,
        numberOfRowsInComponent component: Int) -> Int {
        return _items.count
    }
    
    //コンポーネント数の取得(6)
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
}
