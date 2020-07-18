//
//  ViewController.swift
//  SpyRa
//
//  Created by Miguel Ángel Fernández Carrillo on 18/07/2020.
//

import UIKit
import ARKit

class SpyRAViewController: UIViewController {

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
}

extension SpyRAViewController: ARSCNViewDelegate {
  func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
    
    guard let device = sceneView.device else {
      return nil
    }
    
    let faceGeometry = ARSCNFaceGeometry(device: device)
    let node = SCNNode(geometry: faceGeometry)
    
    node.geometry?.firstMaterial?.fillMode = .lines
    
    return node
  }
}

