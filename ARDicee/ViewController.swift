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
    var dices = [SCNNode]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
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
//        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
//        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
//            diceNode.position = SCNVector3(x: 0, y: 0, z: -0.1)
//            // Set the scene to the view
//            sceneView.scene.rootNode.addChildNode(diceNode)
//        }

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
    
    func createDice() {
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal

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
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor {
            let planeAnchor = anchor as! ARPlaneAnchor
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            
            let planeNode = SCNNode()
            
            planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            let gridMaterial = SCNMaterial()
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            plane.materials = [gridMaterial]
            planeNode.geometry = plane
            node.addChildNode(planeNode)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
            if let hitResult = results.first {
                let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
                if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
                    diceNode.position = SCNVector3(
                        x: hitResult.worldTransform.columns.3.x,
                        y: hitResult.worldTransform.columns.3.y + diceNode.boundingSphere.radius,
                        z: hitResult.worldTransform.columns.3.z)
                    // Set the scene to the view
                    sceneView.scene.rootNode.addChildNode(diceNode)
                    
                    roll(diceNode)
                    dices.append(diceNode)
                }
            }
        }
    }
    
    func rollAll() {
        if !dices.isEmpty {
            for dice in dices {
                roll(dice)
            }
        }
    }
    
    func roll(_ dice: SCNNode) {
        let randomX = Float(arc4random_uniform(4) + 1) * Float.pi / 2
        let randomZ = Float(arc4random_uniform(4) + 1) * Float.pi / 2
        dice.runAction(SCNAction.rotateBy(x: CGFloat(randomX), y: 0, z: CGFloat(randomZ), duration: 0.5))
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        rollAll()
    }
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
