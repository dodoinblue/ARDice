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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        let sunPosition = SCNVector3(x: 0.1, y: 0, z: -3)
        let nodeSun = createSphere(radius: 1, surfaceImgUri: "art.scnassets/sun.jpg", position: sunPosition)
        let earthPosition = SCNVector3(x: 0, y: 0.1, z: -0.5)
        let nodeEarth = createSphere(radius: 0.1, surfaceImgUri: "art.scnassets/earth_daymap.jpg", position: earthPosition)
        let moonPosition = SCNVector3(x: 0.1, y: 0, z: -0.5)
        let nodeMoon = createSphere(radius: 0.02, surfaceImgUri: "art.scnassets/moon.jpg", position: moonPosition)
        sceneView.scene.rootNode.addChildNode(nodeEarth)
        sceneView.scene.rootNode.addChildNode(nodeMoon)
        sceneView.scene.rootNode.addChildNode(nodeSun)
        sceneView.autoenablesDefaultLighting = true
        
//        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
//
//        // Set the scene to the view
//        sceneView.scene = scene
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
