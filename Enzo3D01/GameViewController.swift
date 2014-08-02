//
//  GameViewController.swift
//  Enzo3D01
//
//  Created by Enio Ohmaye on 7/29/14.
//  Copyright (c) 2014 Enio Ohmaye. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import SpriteKit


class GameViewController: UIViewController {
    
    var scnView : SCNView!
    var _scnScene : EnzoScene!
    let Z_POINT_OF_VIEW : Float = 46

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // retrieve the SCNView
        scnView = self.view as SCNView
        _scnScene = EnzoScene()
        
        // create a scene view with an empty scene
        _scnScene.physicsWorld.speed = 1.0
        scnView.scene = _scnScene
        scnView.delegate = _scnScene
        _scnScene.physicsWorld.gravity = SCNVector3(x: 0, y: 0, z: 0)

        // a camera
        var camera = SCNCamera()
        var cameraNode = SCNNode()
        var pointToNode = SCNNode()
        camera.zFar = Double(Z_POINT_OF_VIEW)
        pointToNode.position = SCNVector3Zero
        //cameraNode.constraints = [SCNLookAtConstraint(target: pointToNode)]
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 46)
        scnView.pointOfView = cameraNode
        _scnScene.rootNode.addChildNode(cameraNode)
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = false

        createPlane(60, height: 40, z: 0, isVisible: true )
        createBox(-30, y: 0, z: 3, width: 1, height: 42, length: 6)   // Left wall
        createBox(30, y: 0, z: 3, width: 1, height: 42, length: 6)    // Right wall
        createBox(0, y: 20, z: 3, width: 62, height: 1, length: 6)    // Top wall
        createBox(0, y: -20, z: 3, width: 62, height: 1, length: 6)    // Bottom wall
        createPlane(60, height: 40, z: 6, isVisible: false)
        createTorus(0, y: 0, z: 0)
        createBalls()
        createLight()

        // default lighting
        scnView.autoenablesDefaultLighting = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.blackColor()
    }
    
    func createBalls() {
        // Create geometry that will be shared by all balls
        var sphere = SCNSphere(radius: 1.2)
        sphere.firstMaterial.diffuse.wrapS = SCNWrapMode.Repeat
        sphere.firstMaterial.diffuse.contents = "art.scnassets/ball.jpg"
        sphere.firstMaterial.reflective.contents = "art.scnassets/envmap.jpg"
        sphere.firstMaterial.fresnelExponent = 1.0;
        let physicsBody = SCNPhysicsBody.dynamicBody()
        physicsBody.restitution = 0.9;
        
        for i in stride(from: -10.0, through: 10.0, by: 1.5) {
            var node = SCNNode()
            node.position = SCNVector3Make(Float(i), Float(i), 1)
            node.geometry = sphere
            node.physicsBody = SCNPhysicsBody.dynamicBody()
            _scnScene.rootNode.addChildNode(node)
        }
        var sphere2 = SCNSphere(radius: 1.2)
        sphere2.firstMaterial.diffuse.contents = UIColor.blueColor()
        sphere2.firstMaterial.reflective.contents = "art.scnassets/envmap.jpg"
        
        for i in stride(from: -10.0, through: 10.0, by: 1.5) {
            var node = SCNNode()
            node.position = SCNVector3Make(Float(i+2), Float(i+2), 1)
            node.geometry = sphere2
            node.physicsBody = SCNPhysicsBody.dynamicBody()
            _scnScene.rootNode.addChildNode(node)
        }
        createTorus(1,y: 2,z: 0)
    }
    
    func createTorus( x: Float, y: Float, z: Float ) {
        // a geometry object
        var torus = SCNTorus(ringRadius: 1, pipeRadius: 0.35)
        var torusNode = SCNNode(geometry: torus)
        torusNode.position = SCNVector3(x: x, y: y, z: z)
        torusNode.rotation = SCNVector4Make(90, 90, 90, 90)
        _scnScene.rootNode.addChildNode(torusNode)
        
        // configure the geometry object
        torus.firstMaterial.diffuse.contents  = UIColor.blueColor()
        torus.firstMaterial.specular.contents = UIColor.whiteColor()
        torusNode.opacity = 0.5
        
        // Add physicsfield
        var field = SCNPhysicsField.turbulenceFieldWithSmoothness(0.0, animationSpeed: 0.5)
        field = SCNPhysicsField.vortexField()
        field.strength = 1.0
        torusNode.physicsField = field
    }
    
    func createLight() {
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light.type = SCNLightTypeOmni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        _scnScene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light.type = SCNLightTypeAmbient
        ambientLightNode.light.color = UIColor.darkGrayColor()
        _scnScene.rootNode.addChildNode(ambientLightNode)
    }
    
    
    func createPlane( width: CGFloat, height: CGFloat, z: Float, isVisible: Bool ) {
        var planeNode = SCNNode()
        var planeGeometry = SCNPlane(width: width, height: height)
        planeNode.position = SCNVector3(x: 0, y: 0, z: z)
        planeNode.geometry = planeGeometry
        if isVisible {
            planeNode.geometry.firstMaterial.diffuse.contents = "art.scnassets/wood.png"
            planeNode.geometry.firstMaterial.locksAmbientWithDiffuse = true
            planeNode.geometry.firstMaterial.diffuse.wrapS = SCNWrapMode.Repeat
            planeNode.geometry.firstMaterial.diffuse.wrapT = SCNWrapMode.Repeat
            planeNode.geometry.firstMaterial.diffuse.mipFilter = SCNFilterMode.Linear
        } else {
            planeNode.opacity = 0.0
        }
        planeNode.physicsBody = SCNPhysicsBody.staticBody()
        planeNode.physicsBody.restitution = 1.0;
        
        _scnScene.rootNode.addChildNode(planeNode)
    }
    
    
    func createBox( x: Float, y: Float, z: Float, width: CGFloat, height: CGFloat, length: CGFloat ) {
        var boxNode = SCNNode()
        var boxGeometry = SCNBox(width: width, height: height, length: length, chamferRadius: 0)
        
        boxNode.position = SCNVector3(x: x, y: y, z: z)
        boxNode.geometry = boxGeometry
        boxNode.geometry.firstMaterial.diffuse.contents = "art.scnassets/wood.png"
        boxNode.geometry.firstMaterial.locksAmbientWithDiffuse = true
        boxNode.geometry.firstMaterial.diffuse.wrapS = SCNWrapMode.Repeat
        boxNode.geometry.firstMaterial.diffuse.wrapT = SCNWrapMode.Repeat
        boxNode.geometry.firstMaterial.diffuse.mipFilter = SCNFilterMode.Linear
        
        boxNode.physicsBody = SCNPhysicsBody.staticBody()
        boxNode.physicsBody.restitution = 1.0;
        
        _scnScene.rootNode.addChildNode(boxNode)
    }
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        for touch: AnyObject in touches! {
            let location = touch.locationInView(self.view)
            let pointInView = SCNVector3(x: Float(location.x), y: Float(location.y), z: 0)
            let pointInScene = scnView.unprojectPoint(pointInView)

            println("X Y Z (View) : \(location.x) \(location.y) \(location.y)")
            println("X Y Z (Scene): \(pointInScene.x) \(pointInScene.y) \(pointInScene.y)")
            createTorus(Float(pointInScene.x * Z_POINT_OF_VIEW), y: Float(pointInScene.y * Z_POINT_OF_VIEW), z: 0)
        }
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        
    }
    
    func handleTap(gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.locationInView(scnView)
        let hitResults = scnView.hitTest(p, options: nil)
        
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result: AnyObject! = hitResults[0]
            
            // get its material
            let material = result.node!.geometry.firstMaterial
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.setAnimationDuration(0.5)
            
            // on completion - unhighlight
            SCNTransaction.setCompletionBlock {
                SCNTransaction.begin()
                SCNTransaction.setAnimationDuration(0.5)
                
                material.emission.contents = UIColor.blackColor()
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = UIColor.yellowColor()
            
            SCNTransaction.commit()
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.LandscapeLeft.toRaw())
        } else {
            return Int(UIInterfaceOrientationMask.LandscapeLeft.toRaw())
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
