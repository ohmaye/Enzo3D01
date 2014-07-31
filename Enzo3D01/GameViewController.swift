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
        
        // create a scene view with an empty scene
        //var sceneView = SCNView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
        var scene = SCNScene()
        //sceneView.scene = scene
        

        
        // a camera
        var camera = SCNCamera()
        var cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        scene.rootNode.addChildNode(cameraNode)
        
        // a geometry object
        var torus = SCNTorus(ringRadius: 1, pipeRadius: 0.35)
        var torusNode = SCNNode(geometry: torus)
        scene.rootNode.addChildNode(torusNode)
        
        // configure the geometry object
        torus.firstMaterial.diffuse.contents  = UIColor.redColor()
        torus.firstMaterial.specular.contents = UIColor.whiteColor()
        torusNode.opacity = 0.5
        
        var ball = SCNNode()
        var sphere = SCNSphere(radius: 0.5)
        ball.geometry = sphere;
        ball.geometry.firstMaterial.diffuse.wrapS = SCNWrapMode.Repeat
        ball.geometry.firstMaterial.diffuse.contents = "art.scnassets/ball.jpg"
        ball.geometry.firstMaterial.reflective.contents = "art.scnassets/envmap.jpg"
        ball.geometry.firstMaterial.fresnelExponent = 1.0;
        ball.physicsBody = SCNPhysicsBody.dynamicBody()
        ball.physicsBody.restitution = 0.9;
        var action = SCNAction.rotateByX(0, y: 2, z: 0, duration: 3)
        ball.runAction(SCNAction.repeatActionForever(action))
        scene.rootNode.addChildNode(ball)
        createBalls(scene)
        
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
        
        // retrieve the SCNView
        let scnView = self.view as SCNView
        scnView.allowsCameraControl = true
        // default lighting
        scnView.autoenablesDefaultLighting = true
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
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
        var sphere = SCNSphere(radius: 0.5)
//        ball.geometry = sphere;
        sphere.firstMaterial.diffuse.wrapS = SCNWrapMode.Repeat
        sphere.firstMaterial.diffuse.contents = "art.scnassets/ball.jpg"
        sphere.firstMaterial.reflective.contents = "art.scnassets/envmap.jpg"
        sphere.firstMaterial.fresnelExponent = 1.0;
        let physicsBody = SCNPhysicsBody.dynamicBody()
        physicsBody.restitution = 0.9;
        
        var action = SCNAction.repeatActionForever(SCNAction.rotateByX(0, y: 2, z: 0, duration: 0.1))
//        ball.runAction(SCNAction.repeatActionForever(action))
        
        for i in -10...10 {
            var node = SCNNode()
            node.position = SCNVector3Make(Float(i), Float(i), 0)
            node.geometry = sphere
            //node.runAction(action)
            node.physicsBody = SCNPhysicsBody.dynamicBody()
            scene.rootNode.addChildNode(node)
        }
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
