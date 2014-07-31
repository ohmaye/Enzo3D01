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

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // retrieve the SCNView
        let scnView = self.view as SCNView
        
        // create a scene view with an empty scene
        var scene = SCNScene()
        scene.physicsWorld.speed = 4.0
        scnView.scene = scene
        
        // a camera
        var camera = SCNCamera()
        var cameraNode = SCNNode()
        var pointToNode = SCNNode()
        pointToNode.position = SCNVector3Zero
        cameraNode.constraints = [SCNLookAtConstraint(target: pointToNode)]
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 50)
        scene.rootNode.addChildNode(cameraNode)
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true

        createPlane(scene, width: 40, height: 40, z: 0, isVisible: true )
        createBox(scene, x: -20, y: 0, z: 3, width: 1, height: 40, length: 6)   // Left wall
        createBox(scene, x: 20, y: 0, z: 3, width: 1, height: 40, length: 6)    // Right wall
        createBox(scene, x: 0, y: 20, z: 3, width: 42, height: 1, length: 6)    // Top wall
        createBox(scene, x: 0, y: -20, z: 3, width: 42, height: 1, length: 6)    // Bottom wall
        createPlane(scene, width: 40, height: 40, z: 6, isVisible: false)
        createTorus(scene, x: 0, y: 0, z: 0)
        createBalls(scene)
        createLight(scene)

        // default lighting
        scnView.autoenablesDefaultLighting = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.blackColor()
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
        let gestureRecognizers = NSMutableArray()
        gestureRecognizers.addObject(tapGesture)
        gestureRecognizers.addObjectsFromArray(scnView.gestureRecognizers)
        scnView.gestureRecognizers = gestureRecognizers
    }
    
    
    func createBalls( scene: SCNScene ) {
        // Create geometry that will be shared by all balls
        var sphere = SCNSphere(radius: 1.0)
        sphere.firstMaterial.diffuse.wrapS = SCNWrapMode.Repeat
        sphere.firstMaterial.diffuse.contents = "art.scnassets/ball.jpg"
        sphere.firstMaterial.reflective.contents = "art.scnassets/envmap.jpg"
        sphere.firstMaterial.fresnelExponent = 1.0;
        let physicsBody = SCNPhysicsBody.dynamicBody()
        physicsBody.restitution = 0.9;
        
        var action = SCNAction.repeatActionForever(SCNAction.rotateByX(0, y: 2, z: 0, duration: 0.1))
        
        for i in stride(from: -10.0, through: 10.0, by: 1.5) {
            var node = SCNNode()
            node.position = SCNVector3Make(Float(i), Float(i), 1)
            node.geometry = sphere
            node.physicsBody = SCNPhysicsBody.dynamicBody()
            scene.rootNode.addChildNode(node)
        }
        var sphere2 = SCNSphere(radius: 1.0)
        sphere2.firstMaterial.diffuse.contents = UIColor.blueColor()
        
        for i in stride(from: -10.0, through: 10.0, by: 1.5) {
            var node = SCNNode()
            node.position = SCNVector3Make(Float(i+2), Float(i+2), 1)
            node.geometry = sphere2
            node.physicsBody = SCNPhysicsBody.dynamicBody()
            scene.rootNode.addChildNode(node)
        }
    }
    
    func createTorus( scene: SCNScene, x: Float, y: Float, z: Float ) {
        // a geometry object
        var torus = SCNTorus(ringRadius: 1, pipeRadius: 0.35)
        var torusNode = SCNNode(geometry: torus)
        torusNode.position = SCNVector3(x: x, y: y, z: z)
        torusNode.rotation = SCNVector4Make(90, 90, 90, 90)
        scene.rootNode.addChildNode(torusNode)
        
        // configure the geometry object
        torus.firstMaterial.diffuse.contents  = UIColor.redColor()
        torus.firstMaterial.specular.contents = UIColor.whiteColor()
        torusNode.opacity = 0.5
    }
    
    func createLight( scene: SCNScene ) {
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light.type = SCNLightTypeOmni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light.type = SCNLightTypeAmbient
        ambientLightNode.light.color = UIColor.darkGrayColor()
        scene.rootNode.addChildNode(ambientLightNode)
    }
    
    func createFloor( scene: SCNScene ) {
        //floor
        var floor = SCNFloor()
        floor.reflectionFalloffEnd = 0
        floor.reflectivity = 0
        
        var floorNode = SCNNode()
        floorNode.geometry = floor
        floorNode.geometry.firstMaterial.diffuse.contents = "art.scnassets/wood.png"
        floorNode.geometry.firstMaterial.locksAmbientWithDiffuse = true
        floorNode.geometry.firstMaterial.diffuse.wrapS = SCNWrapMode.Repeat
        floorNode.geometry.firstMaterial.diffuse.wrapT = SCNWrapMode.Repeat
        floorNode.geometry.firstMaterial.diffuse.mipFilter = SCNFilterMode.Linear
        
        floorNode.physicsBody = SCNPhysicsBody.staticBody()
        floorNode.physicsBody.restitution = 1.0;
        
        scene.rootNode.addChildNode(floorNode)
    }
    
    func createPlane( scene: SCNScene, width: CGFloat, height: CGFloat, z: Float, isVisible: Bool ) {
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
        
        scene.rootNode.addChildNode(planeNode)
    }
    
    func createBox( scene: SCNScene, x: Float, y: Float, z: Float, width: CGFloat, height: CGFloat, length: CGFloat ) {
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
        
        scene.rootNode.addChildNode(boxNode)
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
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.toRaw())
        } else {
            return Int(UIInterfaceOrientationMask.All.toRaw())
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
