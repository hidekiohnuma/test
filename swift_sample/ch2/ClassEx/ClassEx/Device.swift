//Deviceクラス(1)
class Device {
    //プロパティの定義(2)
    var name: String = "" //名前
    var version: Int = 0  //バージョン
    
    //メソッドの定義(3)
    func info() -> String {
        return "\(name)のバージョンは\(version)"
    }
    
    //引数なしのイニシャライザ(4)
    convenience init() {
        self.init(name: "none", version: 1)
    }
    
    //引数ありのイニシャライザの定義(4)
    init(name: String, version: Int) {
        self.name = name
        self.version = version
    }
}
