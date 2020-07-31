//
//  ViewController.swift
//  SpyRa
//
//  Created by Miguel Ángel Fernández Carrillo on 18/07/2020.
//

import UIKit
import ARKit

class SpyRAViewController: UIViewController {
    let noseOptions = ["👃", "🐽", "💧", " "]
    let eyeOptions = ["👁", "🌕", "🌟", "🔥", "⚽️", "🔎", " "]
    let mouthOptions = ["👄", "👅", "❤️", " "]
    let hatOptions = ["🎓", "🎩", "🧢", "⛑", "👒", " "]
    
    let features = ["nose", "leftEye", "rightEye", "mouth", "hat"]
    let featureIndices = [[9], [1064], [42], [24, 25], [20]]
    
    @IBOutlet var sceneView: ARSCNView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard ARFaceTrackingConfiguration.isSupported else {
          fatalError("Face tracking is not supported on this device")
        }
        sceneView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
            
      let configuration = ARFaceTrackingConfiguration()
      sceneView.session.run(configuration)
    }
        
    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
            
      sceneView.session.pause()
    }
    
    func updateFeatures(for node: SCNNode, using anchor: ARFaceAnchor) {
        for (feature, indices) in zip(features, featureIndices)  {
          let child = node.childNode(withName: feature, recursively: false) as? EmojiNode
          
          let vertices = indices.map { anchor.geometry.vertices[$0] }
          child?.updatePosition(for: vertices)
        }
    }
    @IBAction func handleTao(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: sceneView)

        let results = sceneView.hitTest(location, options: nil)

        if let result = results.first,
          let node = result.node as? EmojiNode {
          
          node.next()
        }
    }
}

extension SpyRAViewController: ARSCNViewDelegate {
    func renderer(
        _ renderer: SCNSceneRenderer,
        nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let faceAnchor = anchor as? ARFaceAnchor,
          let device = sceneView.device else {
          return nil
        }
        
        let faceGeometry = ARSCNFaceGeometry(device: device)
        let node = SCNNode(geometry: faceGeometry)
    
        node.geometry?.firstMaterial?.fillMode = .lines
        node.geometry?.firstMaterial?.transparency = 0.0

        let noseNode = EmojiNode(with: noseOptions)
        noseNode.name = "nose"
        node.addChildNode(noseNode)

        let leftEyeNode = EmojiNode(with: eyeOptions)
        leftEyeNode.name = "leftEye"
        leftEyeNode.rotation = SCNVector4(0, 1, 0, GLKMathDegreesToRadians(180.0))
        node.addChildNode(leftEyeNode)
            
        let rightEyeNode = EmojiNode(with: eyeOptions)
        rightEyeNode.name = "rightEye"
        node.addChildNode(rightEyeNode)
            
        let mouthNode = EmojiNode(with: mouthOptions)
        mouthNode.name = "mouth"
        node.addChildNode(mouthNode)
            
        let hatNode = EmojiNode(with: hatOptions)
        hatNode.name = "hat"
        node.addChildNode(hatNode)

        updateFeatures(for: node, using: faceAnchor)
    
        return node
    }
    
    func renderer(
      _ renderer: SCNSceneRenderer,
      didUpdate node: SCNNode,
      for anchor: ARAnchor) {
       
      guard let faceAnchor = anchor as? ARFaceAnchor,
        let faceGeometry = node.geometry as? ARSCNFaceGeometry else {
          return
      }
    updateFeatures(for: node, using: faceAnchor)
      faceGeometry.update(from: faceAnchor.geometry)
    }
}

