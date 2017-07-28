//
//  ViewController+Touch.swift
//  drawing
//
//  Created by Jan Luca Siewert on 28.07.17.
//  Copyright © 2017 Jan Luca Siewert. All rights reserved.
//

import UIKit

extension ViewController {
    @IBAction func handleTouch(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        guard let cameraPosition = getCameraPosition(in: sceneView) else {
            return
        }
        let worldPosition = cameraPosition + getDirection(for: location, in: sceneView)
        drawingController.handleNextPoint(worldPosition)
    }
    
    @IBAction func handleDrag(_ sender: UIPanGestureRecognizer) {
        let location = sender.location(in: view)
        guard let cameraPosition = getCameraPosition(in: sceneView) else {
            return
        }
        let worldPosition = cameraPosition + getDirection(for: location, in: sceneView)
        drawingController.handleNextPoint(worldPosition)

        if sender.state == .ended {
            drawingController.endLine()
        }
    }
}
