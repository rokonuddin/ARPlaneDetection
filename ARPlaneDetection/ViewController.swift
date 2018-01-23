//
//  ViewController.swift
//  ARPlaneDetection
//
//  Created by Mohammed Rokon Uddin on 23/1/18.
//  Copyright © 2018 Mohammed Rokon Uddin. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    lazy var scenView: ARSCNView = {
        let scenView = ARSCNView()
        scenView.frame = self.view.frame
        return scenView
    }()

    /// This will hold the added planes and update their height and width later when didUpdate delegate method is called.
    var planes = [UUID: VirtualPlane]()



    override func viewDidLoad() {
        super.viewDidLoad()

        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal

        self.view.addSubview(self.scenView)
        self.scenView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.scenView.session.run(configuration)
        self.scenView.delegate = self

    }
}

// ---------------------------------------------
// MARK: - ARSCNViewDelegate
// ---------------------------------------------

extension ViewController: ARSCNViewDelegate {

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        let plane = VirtualPlane(anchor: planeAnchor)
        self.planes[planeAnchor.identifier] = plane
        node.addChildNode(plane)
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor, let plane = planes[planeAnchor.identifier] else {return}
        plane.updateWithNewAnchor(planeAnchor)
    }

    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor, let index = planes.index(forKey: planeAnchor.identifier) else {
            return
        }
        // If a node has been deleted then we do not need to keep it in the dictionary
        planes.remove(at: index)
    }
}

