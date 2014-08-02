//
//  EnzoScene.swift
//  Enzo3D01
//
//  Created by Enio Ohmaye on 8/1/14.
//  Copyright (c) 2014 Enio Ohmaye. All rights reserved.
//

import UIKit
import SceneKit
import CoreMotion

class EnzoScene: SCNScene, SCNSceneRendererDelegate {
    
    func renderer( aRenderer: SCNSceneRenderer!, updateAtTime time: NSTimeInterval) {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let motionMgr = appDelegate.motionManager
        if let gravity = motionMgr.deviceMotion?.gravity {
            physicsWorld.gravity = SCNVector3(x: Float(gravity.y*2), y: Float(-gravity.x*2), z: Float(gravity.z))
            println("X Y Z: \(gravity.x) - \(gravity.y) - \(gravity.z) ")
        }
    }
}
