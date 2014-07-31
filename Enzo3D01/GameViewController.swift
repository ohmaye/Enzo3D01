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
        scnView.scene = scene
        
        // a camera
        var camera = SCNCamera()
        var cameraNode = SCNNode()
        var pointToNode = SCNNode()
        pointToNode.position = SCNVector3Zero
        cameraNode.constraints = [SCNLookAtConstraint(target: pointToNode)]
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(x: 0, y: 60, z: 0)
        scene.rootNode.addChildNode(cameraNode)
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true

        createFloor(scene)
        createTorus(scene)
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
//        ball.geometry = sphere;
        sphere.firstMaterial.diffuse.wrapS = SCNWrapMode.Repeat
        sphere.firstMaterial.diffuse.contents = "art.scnassets/ball.jpg"
        sphere.firstMaterial.reflective.contents = "art.scnassets/envmap.jpg"
        sphere.firstMaterial.fresnelExponent = 1.0;
        let physicsBody = SCNPhysicsBody.dynamicBody()
        physicsBody.restitution = 0.9;
        
        var action = SCNAction.repeatActionForever(SCNAction.rotateByX(0, y: 2, z: 0, duration: 0.1))
//        ball.runAction(SCNAction.repeatActionForever(action))
        
        for i in stride(from: -10.0, through: 10.0, by: 1.5) {
            var node = SCNNode()
            node.position = SCNVector3Make(Float(i), 1, Float(i))
            node.geometry = sphere
            //node.runAction(action)
            //node.physicsBody = SCNPhysicsBody.dynamicBody()
            scene.rootNode.addChildNode(node)
        }
    }
    
    func createTorus( scene: SCNScene ) {
        // a geometry object
        var torus = SCNTorus(ringRadius: 1, pipeRadius: 0.35)
        var torusNode = SCNNode(geometry: torus)
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
