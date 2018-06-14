import UIKit
import ARKit



class ViewController: UIViewController, UICollectionViewDataSource , UICollectionViewDelegate, ARSCNViewDelegate{
    
    

    
    
    let itemsArray: [String] = ["cup", "benz","newCar","truck"]
    @IBOutlet weak var itemsCollectionView: UICollectionView!
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    var selectedItem: String?
    var wheel1_pivot      : SCNNode!
    var scene: SCNScene?
    var node: SCNNode?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.debugOptions = [ ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        self.configuration.planeDetection = .horizontal
        self.sceneView.session.run(configuration)
        self.itemsCollectionView.dataSource = self
        self.itemsCollectionView.delegate = self
        self.sceneView.delegate = self
        self.registerGestureRecognizers()
        self.sceneView.autoenablesDefaultLighting = true
        
    

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func startRotation() {
//        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
//        rotation.fromValue = 0
//        rotation.toValue = NSNumber(value: Double.pi)
//        rotation.duration = 1.0
//        rotation.isCumulative = true
//        rotation.repeatCount = FLT_MAX
//        self.view.layer.add(rotation, forKey: "rotationAnimation")
//    }
//
//    func stopRotation() {
//        self.view.layer.removeAnimation(forKey: "rotationAnimation")
//    }
    
    func registerGestureRecognizers() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinch))
        self.sceneView.addGestureRecognizer(pinchGestureRecognizer)
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func pinch(sender: UIPinchGestureRecognizer) {
        let sceneView = sender.view as! ARSCNView
        let pinchLocation = sender.location(in: sceneView)
        let hitTest = sceneView.hitTest(pinchLocation)
        
        if !hitTest.isEmpty {
            
            let results = hitTest.first!
            let node = results.node
            let pinchAction = SCNAction.scale(by: sender.scale, duration: 0)
            print(sender.scale)
            node.runAction(pinchAction)
            sender.scale = 1.0
        }
        
        
    }
    
    @objc func tapped(sender: UITapGestureRecognizer) {
        let sceneView = sender.view as! ARSCNView
        let tapLocation = sender.location(in: sceneView)
        let hitTest = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        if !hitTest.isEmpty {
            self.addItem(hitTestResult: hitTest.first!)
        }
    }
    
    func addItem(hitTestResult: ARHitTestResult) {
        if let selectedItem = self.selectedItem {
            scene = SCNScene(named: "art.scnassets/\(selectedItem).scn")
            
             node  = (scene?.rootNode.childNode(withName: selectedItem, recursively: false))!
//            let frontwheelleft = newCar.childNode(withName: "front_wheelleft", recursively: false)!
//            let backwheelleft = newCar.childNode(withName: "back_wheelleft", recursively: false)!
//            let frontwheelright = newCar.childNode(withName: "front_wheelright", recursively: false)!
//            let backwheelright = newCar.childNode(withName: "back_wheelright", recursively: false)!
//
//            let v_frontleftwheel = SCNPhysicsVehicleWheel(node: frontwheelleft)
//             let v_backleftwheel = SCNPhysicsVehicleWheel(node: backwheelleft)
//             let v_frontrightwheel = SCNPhysicsVehicleWheel(node: frontwheelright)
//             let v_backrightwheel = SCNPhysicsVehicleWheel(node: backwheelright)
            
            let transform = hitTestResult.worldTransform
            let thirdColumn = transform.columns.3
            node?.position = SCNVector3(thirdColumn.x, thirdColumn.y, thirdColumn.z)
            
//            let vehicle = SCNPhysicsVehicle(chassisBody: newCar.physicsBody!, wheels: [v_frontleftwheel, v_backleftwheel, v_frontrightwheel, v_backrightwheel])
//            self.sceneView.scene.physicsWorld.addBehavior(vehicle)
            self.sceneView.scene.rootNode.addChildNode  (node!)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as! itemCell
        cell.itemLabel.text = self.itemsArray[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        self.selectedItem = itemsArray[indexPath.row]
        cell?.backgroundColor = UIColor.green
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.orange
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else {return}
    }
    
    @IBAction func btnback(_ sender: Any) {
        if scene != nil && node != nil {


            node?.position = SCNVector3(-2, 0, -2)
            self.sceneView.scene.rootNode.addChildNode(node!)
        }

    }
    @IBAction func btnfoward(_ sender: Any) {

        if scene != nil && node != nil {

            node?.position = SCNVector3(2, 0, 2)
            self.sceneView.scene.rootNode.addChildNode(node!)

        }
    }

}

extension Int {
    
    var degreesToRadians: Double { return Double(self) * .pi/180}
}



