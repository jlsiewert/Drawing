//
//  ViewController+Orientation.swift
//  drawing
//
//  Created by Jan Luca Siewert on 28.07.17.
//  Copyright © 2017 Jan Luca Siewert. All rights reserved.
//

import SceneKit
import ARKit

extension ViewController {
    func getDirection(for point: CGPoint, in view: SCNView) -> SCNVector3 {
        let farPoint  = view.unprojectPoint(SCNVector3(Float(point.x), Float(point.y), 1))
        let nearPoint = view.unprojectPoint(SCNVector3(Float(point.x), Float(point.y), 0))

        let direction = (farPoint - nearPoint).normalized

        return direction
    }

    func getCameraPosition(in view: ARSCNView) -> SCNVector3? {
        guard let lastFrame = view.session.currentFrame else {
            return nil
        }

        let position = lastFrame.camera.transform * float4(x: 0, y: 0, z: 0, w: 1)
        let camera: SCNVector3 = [position.x, position.y, position.z]

        return camera
    }
}
