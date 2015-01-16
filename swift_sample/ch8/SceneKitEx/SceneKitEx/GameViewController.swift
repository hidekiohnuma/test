import UIKit
import QuartzCore
import SceneKit

//ゲームビューコントローラ
class GameViewController: UIViewController {
    
    //ロード完了時に呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SceneKitのビューの設定(1)
        let scnView = self.view as SCNView
        scnView.allowsCameraControl = true //カメラ操作の有効化
        scnView.showsStatistics = true     //FPSとタイミング情報の表示
        scnView.backgroundColor = UIColor( //背景色の指定
            red: 86/255, green: 125/255, blue: 182/255, alpha: 1)
        scnView.scene = SCNScene()         //シーンの指定
        let scene = scnView.scene!
        
        //カメラの生成とシーンへの追加(2)
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 10, z: 0)
        scene.rootNode.addChildNode(cameraNode)
        
        //点光源の生成とシーンへの追加(3)
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLightTypeOmni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        //環境光の生成とシーンへの追加(3)
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLightTypeAmbient
        ambientLightNode.light!.color = UIColor.darkGrayColor()
        scene.rootNode.addChildNode(ambientLightNode)
        
        //3Dモデルの読み込みとシーンへの追加(4)
        let modelScene = SCNScene(named: "art.scnassets/model.dae")!
        let modelNode = modelScene.rootNode.childNodeWithName("model",
            recursively: true)!
        scene.rootNode.addChildNode(modelNode)
        modelNode.position = SCNVector3(x: 0, y: 0, z: -80)
        modelNode.scale = SCNVector3(x: 0.2, y: 0.2, z: 0.2)
        
        //マテリアルの生成とジオメトリへの追加(5)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "texture")
        material.specular.contents = UIColor.grayColor()
        material.locksAmbientWithDiffuse = true
        modelNode.geometry!.firstMaterial = material
        
        //タップジェスチャーの追加(6)
        let tapGesture = UITapGestureRecognizer(target: self, action: "onTap:")
        let gestureRecognizers = NSMutableArray()
        gestureRecognizers.addObject(tapGesture)
        gestureRecognizers.addObjectsFromArray(scnView.gestureRecognizers!)
        scnView.gestureRecognizers = gestureRecognizers
    }
    
    //タップ時に呼ばれる
    func onTap(gestureRecognize: UIGestureRecognizer) {
        //タップしたノードの取得(7)
        let scnView = self.view as SCNView
        let pos = gestureRecognize.locationInView(scnView)
        let hitResults = scnView.hitTest(pos, options: nil)
        if hitResults!.count > 0 {
            let node = hitResults![0].node!
            
            //マテリアルへのアニメーションの追加(8)
            let material = node.geometry!.firstMaterial
            SCNTransaction.begin()
            SCNTransaction.setAnimationDuration(0.5)
            SCNTransaction.setCompletionBlock {
                SCNTransaction.begin()
                SCNTransaction.setAnimationDuration(0.5)
                material!.emission.contents = UIColor.blackColor()
                SCNTransaction.commit()
            }
            material!.emission.contents = UIColor.yellowColor()
            SCNTransaction.commit()
        }
    }
}
