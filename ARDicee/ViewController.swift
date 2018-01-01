//
//  ViewController.swift
//  ARDicee
//
//  Created by charles.liu on 2017-12-31.
//  Copyright © 2017 Charles Liu. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var animations = [String: CAAnimation]()
    var idle: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
//        let sunPosition = SCNVector3(x: 0.1, y: 0, z: -3)
//        let nodeSun = createSphere(radius: 1, surfaceImgUri: "art.scnassets/sun.jpg", position: sunPosition)
//        let earthPosition = SCNVector3(x: 0, y: 0.1, z: -0.5)
//        let nodeEarth = createSphere(radius: 0.1, surfaceImgUri: "art.scnassets/earth_daymap.jpg", position: earthPosition)
//        let moonPosition = SCNVector3(x: 0.1, y: 0, z: -0.5)
//        let nodeMoon = createSphere(radius: 0.02, surfaceImgUri: "art.scnassets/moon.jpg", position: moonPosition)
//        sceneView.scene.rootNode.addChildNode(nodeEarth)
//        sceneView.scene.rootNode.addChildNode(nodeMoon)
//        sceneView.scene.rootNode.addChildNode(nodeSun)
        sceneView.autoenablesDefaultLighting = true
        
        // Create a new scene
        // Set the scene to the view
        sceneView.scene = SCNScene()
        
        let scene = SCNScene(named: "art.scnassets/MaryJaneDancing.scn")!
        
        let node = SCNNode()
        for child in scene.rootNode.childNodes {
            node.addChildNode(child)
        }
        
        // Set up some properties
        node.position = SCNVector3(0, -1, -2)
        node.scale = SCNVector3(0.2, 0.2, 0.2)
        print("\(node)")
        node.animationPlayer(forKey: "mixamorig_Hips")?.play()
        sceneView.scene.rootNode.addChildNode(node)
//        loadAnimation(withKey: "dancing", sceneName: "art.scnassets/MaryJaneDancing.scn", animationIdentifier: "twist_danceFixed-1")
    }
    
    func createSphere(radius: CGFloat, surfaceImgUri: String, position: SCNVector3) -> SCNNode {
        let sphere = SCNSphere(radius: radius)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: surfaceImgUri)
        sphere.materials = [material]
        
        let node = SCNNode()
        node.position = position
        node.geometry = sphere
        return node
    }
    
    func loadAnimation(withKey: String, sceneName:String, animationIdentifier:String) {
        let sceneURL = Bundle.main.url(forResource: sceneName, withExtension: "dae")
        let sceneSource = SCNSceneSource(url: sceneURL!, options: nil)
        
        if let animationObject = sceneSource?.entryWithIdentifier(animationIdentifier, withClass: CAAnimation.self) {
            // The animation will only play once
            animationObject.repeatCount = 1
            // To create smooth transitions between animations
            animationObject.fadeInDuration = CGFloat(1)
            animationObject.fadeOutDuration = CGFloat(0.5)
            
            // Store the animation for later use
            animations[withKey] = animationObject
        }
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let location = touches.first!.location(in: sceneView)
//
//        // Let's test if a 3D Object was touch
//        var hitTestOptions = [SCNHitTestOption: Any]()
//        hitTestOptions[SCNHitTestOption.boundingBoxOnly] = true
//
//        let hitResults: [SCNHitTestResult]  = sceneView.hitTest(location, options: hitTestOptions)
//
//        if hitResults.first != nil {
//            if(idle) {
//                playAnimation(key: "dancing")
//            } else {
//                stopAnimation(key: "dancing")
//            }
//            idle = !idle
//            return
//        }
//    }
    
    func playAnimation(key: String) {
        // Add the animation to start playing it right away
        sceneView.scene.rootNode.addAnimation(animations[key]!, forKey: key)
    }
    
    func stopAnimation(key: String) {
        // Stop the animation with a smooth transition
        sceneView.scene.rootNode.removeAnimation(forKey: key, blendOutDuration: CGFloat(0.5))
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
