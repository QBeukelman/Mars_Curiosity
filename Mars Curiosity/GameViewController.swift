//
//  GameViewController.swift
//  SceneKit Game

//  Copyright @ Quentin Beukelman 2022.

//  Created by Quentin Beukelman on 28/03/2022.
//

import UIKit
import SceneKit


enum BodyType: Int {
    case car = 1
    case floor = 2
}


class GameViewController: UIViewController, SCNPhysicsContactDelegate {
    
    // Vehicle Variables
    var sceneView: SCNView!
    var scene: SCNScene!
    var vehicle: SCNPhysicsVehicle!
    var steeringAxis: SCNVector3!
    var chassisNode: SCNNode!
    var turnL: Int = 0
    var turnR: Int = 0
    var handBreak: Int = 0

    
    // UI Vairables
    var menuView: UIView!
    var beginMenuView: UIView!
    var blurEffectViewMenu: UIView!
    
    var beginMenuButton: UIButton!
    var handBreakButton: UIButton!
    var menuButton: UIButton!
    var leftButton: UIButton!
    var rightButton: UIButton!
    var beginPlanetsButton: UIButton!

    var screenSize: CGRect!
    
    var welcomeLabel: UILabel!
    var explainationLabel: UILabel!
    var marsLabel: UILabel!
    
    var timer = Timer()
    var compassImageView: UIImageView = UIImageView()
    var speedLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        screenSize = UIScreen.main.bounds
        
        setUpPlanetsScene()
        addBeginingView()

    }
    
    
    // MARK: - addMenuView
    func addMenuView() {
        
        menuView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 300))
        menuView.layer.backgroundColor = UIColor.red.cgColor
        
        let exitMenuButton = UIButton(type: .system)
            exitMenuButton.tintColor = UIColor.black
            exitMenuButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 25)
            exitMenuButton.setTitle("Resume", for: .normal)
            exitMenuButton.sizeToFit()
            exitMenuButton.addTarget(self, action: #selector(didPressExitMenu), for: .touchUpInside)
        exitMenuButton.center.x = screenSize.width/2
            exitMenuButton.center.y = 150
        
        menuView.addSubview(exitMenuButton)
        
        self.view.addSubview(menuView)
        menuView.isHidden = true
    }
    
    
    func addPlanetsView() {
        beginPlanetsButton = UIButton(type: .system)
        beginPlanetsButton.tintColor = UIColor.black
        beginPlanetsButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 25)
        beginPlanetsButton.setTitleColor(UIColor.white, for: .normal)
        beginPlanetsButton.setTitle("Land", for: .normal)
        beginPlanetsButton.backgroundColor = UIColor.blue
        beginPlanetsButton.layer.cornerRadius = 10
        beginPlanetsButton.frame.size = CGSize(width: screenSize.width-40, height: 60)
        beginPlanetsButton.addTarget(self, action: #selector(didBeginPlanetsGo), for: .touchUpInside)
        beginPlanetsButton.center.x = (screenSize.width/2)
        beginPlanetsButton.center.y = (screenSize.height-100)
        self.view.addSubview(beginPlanetsButton)
        
        marsLabel = UILabel(frame: CGRect(x: 0, y: 0,width: screenSize.width-40, height: screenSize.height/3))
        marsLabel.textColor = UIColor.white
        marsLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 36)
        marsLabel.center.x = screenSize.width/2
        marsLabel.center.y = 100
        marsLabel.numberOfLines = 3
        marsLabel.textAlignment = .center
        marsLabel.text = "The Red Planet"
        self.view.addSubview(marsLabel)

    }
    

    // MARK: - addBeginingView
    func addBeginingView() {
        
        beginMenuView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.width))
        beginMenuView.layer.backgroundColor = UIColor.red.cgColor
    
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        blurEffectViewMenu = UIVisualEffectView(effect: blurEffect)
        blurEffectViewMenu.frame = view.bounds
        blurEffectViewMenu.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectViewMenu)
        
        welcomeLabel = UILabel(frame: CGRect(x: 0, y: 0,width: screenSize.width-40, height: screenSize.height/3))
        welcomeLabel.textColor = UIColor.white
        welcomeLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 36)
        welcomeLabel.center.x = screenSize.width/2
        welcomeLabel.center.y = 200
        welcomeLabel.numberOfLines = 3
        welcomeLabel.textAlignment = .center
        welcomeLabel.text = "Welcome to the Mars Curiosity Rover vehicle physics demo"
        self.view.addSubview(welcomeLabel)
        
        explainationLabel = UILabel(frame: CGRect(x: 0, y: 0,width: screenSize.width-40, height: screenSize.height/3))
        explainationLabel.textColor = UIColor.white
        explainationLabel.font = UIFont(name: "HelveticaNeue", size: 17)
        explainationLabel.center.x = screenSize.width/2
        explainationLabel.center.y = screenSize.height/2
        explainationLabel.numberOfLines = 3
        explainationLabel.textAlignment = .center
        explainationLabel.text = "The Curiosity Rover accelarates automatically. Press 'Left' + 'Right' to apply the breaks."
        self.view.addSubview(explainationLabel)
        
        beginMenuButton = UIButton(type: .system)
        beginMenuButton.tintColor = UIColor.black
        beginMenuButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 25)
        beginMenuButton.setTitleColor(UIColor.white, for: .normal)
        beginMenuButton.setTitle("Begin", for: .normal)
        beginMenuButton.backgroundColor = UIColor.blue
        beginMenuButton.layer.cornerRadius = 10
        beginMenuButton.frame.size = CGSize(width: screenSize.width-40, height: 60)
        beginMenuButton.addTarget(self, action: #selector(didBeginMenuGo), for: .touchUpInside)
        beginMenuButton.center.x = (screenSize.width/2)
        beginMenuButton.center.y = (screenSize.height-100)
        self.view.addSubview(beginMenuButton)
        
        self.view.addSubview(beginMenuView)
        beginMenuView.isHidden = true
        blurEffectViewMenu.isHidden = false
        
    }
    
    
    // MARK: - setUpScene
    func setUpPlanetsScene() {
        sceneView = self.view as? SCNView
        sceneView.allowsCameraControl = true
        scene = SCNScene(named: "planetsMenu.scn")
        sceneView.scene = scene
        
    }
    
    func setUpCarScene() {
        
        // Show physics shapes
        sceneView.debugOptions = [.showPhysicsShapes]
        
        // SetUp car scene
        sceneView = self.view as? SCNView
        sceneView.allowsCameraControl = false
        scene = SCNScene(named: "Olympus_Mons.scn")
        sceneView.scene = scene
        sceneView.scene?.physicsWorld.contactDelegate = self
        
        func floorPhysBody(type: SCNPhysicsBodyType = .static, shape: SCNGeometry, scale: SCNVector3 = SCNVector3(1.0,1.0,1.0)) -> SCNPhysicsBody {
            
            // Create Physics Body and set Physics Properties
            let body = SCNPhysicsBody(type: type, shape: SCNPhysicsShape(geometry: shape, options: [SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.concavePolyhedron, SCNPhysicsShape.Option.scale: scale]))
            
            // Physics Config
            body.isAffectedByGravity = false
            return body
        }
        
        // configure Physics Floor
        let mountain = scene!.rootNode.childNode(withName: "mountain", recursively: true)!
        mountain.physicsBody = floorPhysBody(type: .static, shape: mountain.geometry!)
    }

    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        print("contact!")
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didEnd contact: SCNPhysicsContact) {
        print("contact ended")
    }
    
    
    
    // MARK: - setUpCar
    func setUpCar() {

        chassisNode = scene!.rootNode.childNode(withName: "car", recursively: true)!
        
        let body = SCNPhysicsBody.dynamic()
            body.allowsResting = false
            body.mass = 300
            body.restitution = 0.1
            body.friction = 0
            body.rollingFriction = 1
            chassisNode.physicsBody = body
            scene.rootNode.addChildNode(chassisNode)
        
        // Add Wheels
        let wheelnode0 = chassisNode.childNode(withName: "wheelLocator_FL", recursively: true)!
        let wheelnode1 = chassisNode.childNode(withName: "wheelLocator_FR", recursively: true)!
        let wheelnode2 = chassisNode.childNode(withName: "wheelLocator_RL", recursively: true)!
        let wheelnode3 = chassisNode.childNode(withName: "wheelLocator_RR", recursively: true)!
        let wheel0 = SCNPhysicsVehicleWheel(node: wheelnode0)
        let wheel1 = SCNPhysicsVehicleWheel(node: wheelnode1)
        let wheel2 = SCNPhysicsVehicleWheel(node: wheelnode2)
        let wheel3 = SCNPhysicsVehicleWheel(node: wheelnode3)
        let min = SCNVector3(x: 0, y: 0, z: 0)
        let max = SCNVector3(x: 0, y: 0, z: 0)
        wheelnode0.boundingBox.max = max
        wheelnode0.boundingBox.min = min
    
        wheel0.suspensionStiffness = 0.1
        wheel1.suspensionStiffness = 0.1
        wheel2.suspensionStiffness = 1
        wheel3.suspensionStiffness = 1
        
        wheel0.maximumSuspensionTravel = 5000
        wheel1.maximumSuspensionTravel = 5000
        wheel2.maximumSuspensionTravel = 5000
        wheel3.maximumSuspensionTravel = 5000

        wheel0.suspensionRestLength = 0.5
        wheel1.suspensionRestLength = 0.5
        wheel2.suspensionRestLength = 0.5
        wheel3.suspensionRestLength = 0.5
        
        wheel0.frictionSlip = 1
        wheel1.frictionSlip = 1
        wheel2.frictionSlip = 0.5
        wheel3.frictionSlip = 0.5
        
        let wheelHalfWidth = Float(0.5 * (max.x - min.x))
        SCNVector3Make(wheelHalfWidth * 5.2, 0, 0)
        
        vehicle = SCNPhysicsVehicle(chassisBody: chassisNode.physicsBody!, wheels: [wheel1, wheel0, wheel3, wheel2])

        scene.physicsWorld.addBehavior(vehicle)
        loadCompass()
        
    }
    
    // MARK: - getPosition
    func getPosition() {
        
        print("The current position is: \(chassisNode.presentation.eulerAngles.y)")
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { _ in
            self.compassImageView.transform = CGAffineTransform.identity
            self.compassImageView.transform = self.compassImageView.transform.rotated(by: .pi * CGFloat(self.chassisNode.presentation.eulerAngles.y))
            self.speedLabel.text = "\(Int(self.vehicle.speedInKilometersPerHour))"
        })
    }
    
    // MARK: - compass
    func loadCompass() {
        let compassImage = UIImage(named: "Compass.png")
        
       // let compassImageView:UIImageView = UIImageView()
        compassImageView.contentMode = UIView.ContentMode.scaleAspectFit
        compassImageView.frame.size.width = 30
        compassImageView.frame.size.height = 30
        compassImageView.center.y = 40
        compassImageView.center.x = (screenSize.width-40)
        compassImageView.image = compassImage
        
        speedLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 21))
        speedLabel.textColor = UIColor.white
        speedLabel.font = UIFont(name: "Orbitron", size: 12)
        speedLabel.center.y = 80
        speedLabel.textAlignment = .right
        speedLabel.center.x = (screenSize.width-50)
        speedLabel.text = "0"
        
        view.addSubview(compassImageView)
        view.addSubview(speedLabel)
 
        self.view = view
        getPosition()
    }

    
    // MARK: - addUserInterface
    func addUserInterface() {

        menuButton = UIButton(type: .system)
            menuButton.tintColor = UIColor.black
            menuButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 17)
            menuButton.setTitle("Menu", for: .normal)
            menuButton.sizeToFit()
            menuButton.addTarget(self, action: #selector(didPressMenu), for: .touchUpInside)
            menuButton.center.x = (screenSize.width/2)
            menuButton.frame.origin.y = (screenSize.height-70)
        sceneView.addSubview(menuButton)
        
//        handBreakButton = UIButton(type: .system)
//            handBreakButton.tintColor = UIColor.black
//            handBreakButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 17)
//            handBreakButton.setTitle("Hand Break", for: .normal)
//            handBreakButton.sizeToFit()
//            handBreakButton.addTarget(self, action: #selector(didPressHandBreak), for: .touchUpInside)
//            handBreakButton.center.x = (screenSize.width/2)
//            handBreakButton.frame.origin.y = (screenSize.height-120)
//        sceneView.addSubview(handBreakButton)
        
        // Streeing
        leftButton = UIButton(type: .system)
            leftButton.tintColor = UIColor.white
            leftButton.titleLabel?.font = UIFont(name: "Orbitron", size: 30)
            leftButton.setTitle("L", for: .normal)
            leftButton.frame.size = CGSize(width: 120, height: 160)
            leftButton.layer.borderWidth = 2
            leftButton.layer.borderColor = UIColor.red.cgColor
            leftButton.addTarget(self, action: #selector(didPressLeft), for: .touchDown)
            leftButton.addTarget(self, action: #selector(didReleaseLeftStreeing), for: .touchUpInside)
            leftButton.center.x = 50
        leftButton.center.y = (screenSize.height-80)
        sceneView.addSubview(leftButton)
        
        rightButton = UIButton(type: .system)
            rightButton.tintColor = UIColor.white
            rightButton.titleLabel?.font = UIFont(name: "Orbitron", size: 30)
            rightButton.setTitle("R", for: .normal)
            rightButton.frame.size = CGSize(width: 120, height: 160)
            rightButton.layer.borderWidth = 2
            rightButton.layer.borderColor = UIColor.red.cgColor
            rightButton.addTarget(self, action: #selector(didPressRight), for: .touchDown)
            rightButton.addTarget(self, action: #selector(didReleaseRightStreeing), for: .touchUpInside)
            rightButton.center.x = (screenSize.width-50)
        rightButton.center.y = (screenSize.height-80)
        sceneView.addSubview(rightButton)
        
    }
    
    
    
    // MARK: - engineForce
    func engineForce() {
        
        vehicle.applyBrakingForce(0, forWheelAt: 0)
        vehicle.applyBrakingForce(0, forWheelAt: 1)
        vehicle.applyBrakingForce(0, forWheelAt: 2)
        vehicle.applyBrakingForce(0, forWheelAt: 3)
        
        vehicle.applyEngineForce(5000, forWheelAt: 0)
        vehicle.applyEngineForce(5000, forWheelAt: 1)
        vehicle.applyEngineForce(100, forWheelAt: 2)
        vehicle.applyEngineForce(100, forWheelAt: 3)
    }
    
    // MARK: - brakingForce
    func brakingForce() {
        
        vehicle.applyBrakingForce(-2000, forWheelAt: 0)
        vehicle.applyBrakingForce(-2000, forWheelAt: 1)
        vehicle.applyBrakingForce(-2000, forWheelAt: 2)
        vehicle.applyBrakingForce(-2000, forWheelAt: 3)
        
        vehicle.setSteeringAngle(0, forWheelAt: 0)
        vehicle.setSteeringAngle(0, forWheelAt: 1)
    }
    
    // MARK: - reverseEngineForce
    func reverseEngineForce() {
        
        vehicle.applyBrakingForce(0, forWheelAt: 0)
        vehicle.applyBrakingForce(0, forWheelAt: 1)
        vehicle.applyBrakingForce(0, forWheelAt: 2)
        vehicle.applyBrakingForce(0, forWheelAt: 3)
        
        vehicle.applyEngineForce(200, forWheelAt: 0)
        vehicle.applyEngineForce(200, forWheelAt: 1)
        vehicle.applyEngineForce(200, forWheelAt: 2)
        vehicle.applyEngineForce(200, forWheelAt: 3)
    }
    
    
    // MARK: - brakingForce
    func brakingForceTurnButtons() {
        
        if turnL == 1 && turnR == 1 {
            vehicle.setSteeringAngle(0, forWheelAt: 0)
            vehicle.setSteeringAngle(0, forWheelAt: 1)
            reverseEngineForce()
        } else {
            engineForce()
        }
    }
    
    
    // MARK: - handBreak
    func handBreakCar() {
        
        if handBreak == 0 {
            // Hand Break ON
            handBreak = 1
            brakingForce()
            handBreakButton.setTitle("GO", for: .normal)
        } else if handBreak == 1 {
            // Hand Break OFF
            handBreak = 0
            engineForce()
            handBreakButton.setTitle("Hand Break", for: .normal)
        }
    }

    
    
    // MARK: - UI Buttons
    @objc func didPressHandBreak (sender: UIButton!) {
        handBreakCar()
    }
    
    @objc func didBeginMenuGo (sender: UIButton!) {
        beginMenuView.isHidden = true
        blurEffectViewMenu.isHidden = true
        beginMenuButton.isHidden = true
        welcomeLabel.isHidden = true
        explainationLabel.isHidden = true
        addPlanetsView()
    }
    
    
    @objc func didBeginPlanetsGo (sender: UIButton!) {
        beginPlanetsButton.isHidden = true
        marsLabel.isHidden = true
        setUpCarScene()
        setUpCar()
        addUserInterface()
        addMenuView()
        engineForce()
    }
    
    
    @objc func didPressMenu (sender: UIButton!) {
        vehicle.applyBrakingForce(1, forWheelAt: 0)
        vehicle.applyBrakingForce(1, forWheelAt: 1)
        vehicle.applyBrakingForce(10, forWheelAt: 2)
        vehicle.applyBrakingForce(10, forWheelAt: 3)
        
        vehicle.setSteeringAngle(0, forWheelAt: 0)
        vehicle.setSteeringAngle(0, forWheelAt: 1)
        menuView.isHidden = false
        
        handBreakButton.isEnabled = false
        menuButton.isEnabled = false
        leftButton.isEnabled = false
        rightButton.isEnabled = false
    }
    
    @objc func didPressExitMenu (sender: UIButton!) {
        engineForce()
        menuView.isHidden = true
        
        handBreakButton.isEnabled = true
        menuButton.isEnabled = true
        leftButton.isEnabled = true
        rightButton.isEnabled = true
    }
    
    @objc func didPressLeft (sender: UIButton!) {
        vehicle.setSteeringAngle(0.5, forWheelAt: 0)
        vehicle.setSteeringAngle(0.5, forWheelAt: 1)
        turnL = 1
        brakingForceTurnButtons()
    }
    
    @objc func didPressRight(sender: UIButton!) {
        vehicle.setSteeringAngle(-0.5, forWheelAt: 0)
        vehicle.setSteeringAngle(-0.5, forWheelAt: 1)
        turnR = 1
        brakingForceTurnButtons()
    }
    
    @objc func didReleaseLeftStreeing (sender: UIButton!) {
        vehicle.setSteeringAngle(0, forWheelAt: 0)
        vehicle.setSteeringAngle(0, forWheelAt: 1)
        turnL = 0
        brakingForceTurnButtons()
    }
    
    @objc func didReleaseRightStreeing (sender: UIButton!) {
        vehicle.setSteeringAngle(0, forWheelAt: 0)
        vehicle.setSteeringAngle(0, forWheelAt: 1)
        turnR = 0
        brakingForceTurnButtons()
    }
    
    
    // MARK: - Settings
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    

} // End Class














// MARK: - Archive


/*
// Connet Wheels to Chasis
let wheel0Position = wheelnode0.convertPosition(SCNVector3Zero, to: chassisNode)
let vector0Float3 = vector_float3(wheel0Position.x, wheel0Position.y, wheel0Position.z) + vector_float3(wheelHalfWidth, 0,0)
wheel0.connectionPosition = SCNVector3(vector0Float3.x, vector0Float3.y, vector0Float3.z)

let wheel1Position = wheelnode1.convertPosition(SCNVector3Zero, to: chassisNode)
let vector1Float3 = vector_float3(wheel1Position.x, wheel1Position.y, wheel1Position.z) - vector_float3(wheelHalfWidth, 0,0)
wheel1.connectionPosition = SCNVector3(vector1Float3.x, vector1Float3.y, vector1Float3.z)

let wheel2Position = wheelnode2.convertPosition(SCNVector3Zero, to: chassisNode)
let vector2Float3 = vector_float3(wheel2Position.x, wheel2Position.y, wheel2Position.z) + vector_float3(wheelHalfWidth, 0,0)
wheel2.connectionPosition = SCNVector3(vector2Float3.x, vector2Float3.y, vector2Float3.z)

let wheel3Position = wheelnode3.convertPosition(SCNVector3Zero, to: chassisNode)
let vector3Float3 = vector_float3(wheel3Position.x, wheel3Position.y, wheel3Position.z) - vector_float3(wheelHalfWidth, 0,0)
wheel3.connectionPosition = SCNVector3(vector3Float3.x, vector3Float3.y, vector3Float3.z)

// Wheel Axle
wheel0.axle = SCNVector3(x: 0,y: 0,z: 1)
wheel1.axle = SCNVector3(x: 0,y: 0,z: 1)
wheel2.axle = SCNVector3(x: 0,y: 0,z: 1)
wheel3.axle = SCNVector3(x: 0,y: 0,z: 1)

wheel0.steeringAxis = SCNVector3Make(0, -1, 1) //wheels point up in the air with 0,1,0
wheel1.steeringAxis = SCNVector3Make(0, -1, 1)
wheel2.steeringAxis = SCNVector3Make(0, -1, 1)
wheel3.steeringAxis = SCNVector3Make(0, -1, 1)
*/




/*
let mountain = scene!.rootNode.childNode(withName: "mountain", recursively: true)!
let floor = SCNNode()
let floorPhysicsBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(node:mountain))
floor.physicsBody?.categoryBitMask = BodyType.floor.rawValue
floor.physicsBody?.collisionBitMask = BodyType.car.rawValue
floor.physicsBody?.contactTestBitMask = BodyType.car.rawValue
floorPhysicsBody.allowsResting = true
floor.physicsBody = floorPhysicsBody
scene.rootNode.addChildNode(floor)
 */




/*
// Catagory and collision bit masks
wheelnode0.physicsBody?.categoryBitMask = BodyType.car.rawValue
wheelnode0.physicsBody?.collisionBitMask = BodyType.floor.rawValue

wheelnode1.physicsBody?.categoryBitMask = BodyType.car.rawValue
wheelnode1.physicsBody?.collisionBitMask = BodyType.floor.rawValue

wheelnode2.physicsBody?.categoryBitMask = BodyType.car.rawValue
wheelnode2.physicsBody?.collisionBitMask = BodyType.floor.rawValue

wheelnode3.physicsBody?.categoryBitMask = BodyType.car.rawValue
wheelnode3.physicsBody?.collisionBitMask = BodyType.floor.rawValue

chassisNode.physicsBody?.categoryBitMask = BodyType.car.rawValue
chassisNode.physicsBody?.collisionBitMask = BodyType.floor.rawValue
*/


//
//// add ball
//let ball = SCNNode()
//ball.position = SCNVector3Make(-5, 5, -18)
//ball.geometry = SCNSphere(radius: 5)
//ball.geometry!.firstMaterial!.locksAmbientWithDiffuse = true
//ball.geometry!.firstMaterial!.diffuse.contents = "ball.jpg"
//ball.geometry!.firstMaterial!.diffuse.contentsTransform = SCNMatrix4MakeScale(2, 1, 1)
//ball.geometry!.firstMaterial!.diffuse.wrapS = .mirror
//ball.physicsBody = SCNPhysicsBody.dynamic()
//ball.physicsBody!.restitution = 0.9
//scene.rootNode.addChildNode(ball)
