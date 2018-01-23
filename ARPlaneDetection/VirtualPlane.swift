//
//  VirtualPlane.swift
//  ARPlaneDetection
//
//  Created by Mohammed Rokon Uddin on 23/1/18.
//  Copyright © 2018 Mohammed Rokon Uddin. All rights reserved.
//

import Foundation
import ARKit

class VirtualPlane: SCNNode {
    var anchor: ARPlaneAnchor!
    var planeGeometry: SCNPlane!

    init(anchor: ARPlaneAnchor) {
        super.init()

        self.anchor = anchor
        self.planeGeometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        let material = initializePlaneMaterial()

        // Seting double sided is true will make the plane to visible from both sides.
        material.isDoubleSided = true
        self.planeGeometry.materials = [material]

        let planeNode = SCNNode(geometry: self.planeGeometry)
        planeNode.position = SCNVector3(anchor.center.x, anchor.center.y, anchor.center.z)

        // Planes in SceneKit are vertical, we need to rotate it 90 in x axis to make it horizontal.
        planeNode.eulerAngles = SCNVector3(90.degreesToRadians, 0, 0)
        updatePlaneMaterialDimensions()

        self.addChildNode(planeNode)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initializePlaneMaterial() -> SCNMaterial {
        let material = SCNMaterial()
        material.diffuse.contents = #imageLiteral(resourceName: "tron_grid")
        return material
    }


    private func updatePlaneMaterialDimensions() {
        let material = self.planeGeometry.materials.first

        let width = Float(self.planeGeometry.width)
        let height = Float(self.planeGeometry.height)
        material?.diffuse.contentsTransform = SCNMatrix4MakeScale(width, height, 1.0)

    }

    func updateWithNewAnchor(_ anchor: ARPlaneAnchor) {
        self.planeGeometry.width = CGFloat(anchor.extent.x)
        self.planeGeometry.height = CGFloat(anchor.extent.z)

        self.position = SCNVector3(anchor.center.x, 0, anchor.center.z)
        updatePlaneMaterialDimensions()
    }
}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi/180 }
}
