//
//  DrawingController.swift
//  drawing
//
//  Created by Jan Luca Siewert on 28.07.17.
//  Copyright © 2017 Jan Luca Siewert. All rights reserved.
//

import SceneKit

class DrawingController: NSObject {

    let baseNode = SCNNode()
    var points: [SCNNode] = []
    var lastPoint: SCNVector3?

    var drawingColor: UIColor = .lightGray {
        didSet {
            currentMaterial = generateMaterial(fromColor: drawingColor)
        }
    }

    var currentMaterial: SCNMaterial!

    override init() {
        super.init()

        currentMaterial = generateMaterial(fromColor: drawingColor)
    }

    deinit {
        clear()
    }

    func clear() {
        points.forEach {$0.removeFromParentNode()}
        points = []
        lastPoint = nil
    }

    func generateMaterial(fromColor color: UIColor) -> SCNMaterial {
        let m = SCNMaterial()
        m.diffuse.contents = color
        m.lightingModel = .physicallyBased
        m.roughness.contents = 0.1
        m.metalness.contents = 0
        return m
    }

    func generateConnection(with pointA: SCNVector3, to pointB: SCNVector3, radius: CGFloat) -> SCNNode {
        // The desired center line of the cylinder
        let vector = pointA - pointB

        // Generate a SCNCylider
        // The radius is passed as an argument, the height is the length
        // of the disired center line
        let cylinder = SCNCylinder(radius: radius, height: CGFloat(vector.length))
        cylinder.materials = [currentMaterial]
        // Reduce the number of triangles used for rendering
        // cylinder.radialSegmentCount = 8
        // cylinder.heightSegmentCount = 2

        // Wrap the Cylinder in a SCNNode
        let node = SCNNode(geometry: cylinder)

        // Calculate the angle, simplified because we
        // know the of our cylinder was parallel to (0, 1, 0)
        let angle = acos(vector.y / vector.length)

        // Move the center of the cylinder to the center between
        // the two points
        node.position = pointA.center(to: pointB)
        // The rotation axis actually is the cross product
        // between (0, 1, 0) and the vector
        node.rotation = SCNVector4(vector.z, 0, -vector.x, angle)

        return node
    }

    func placeSphere(at point: SCNVector3, radius: CGFloat) -> SCNNode {
        let sphere = SCNSphere(radius: 0.02)
        sphere.materials = [currentMaterial]
        let node = SCNNode(geometry: sphere)
        node.position = point
        return node
    }

    func handleNextPoint(_ point: SCNVector3) {
        let node = SCNNode()
        let radius: CGFloat = 0.02

        node.addChildNode(placeSphere(at: point, radius: radius))

        if let lastPoint = lastPoint {
            node.addChildNode(generateConnection(with: lastPoint, to: point, radius: radius))
        }
        lastPoint = point

        points.append(node)

        baseNode.addChildNode(node)
    }

    func endLine() {
        lastPoint = nil
    }
}
