//
//  ViewController.swift
//  drawing
//
//  Created by Jan Luca Siewert on 28.07.17.
//  Copyright © 2017 Jan Luca Siewert. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, ColorSelectionViewControllerDelegate {

    @IBOutlet var sceneView: ARSCNView!
    let drawingController = DrawingController()

    @IBOutlet var colorButton: UIButton!

    @IBOutlet var overlayView: UIView!

    lazy var colorSelectionViewController: ColorSelectionViewController = {
        let colors: [ColorSelectionViewController.ColorSelection] = [.red, .green, .blue, .yellow, .gray, .orange]
        let vc = ColorSelectionViewController(colors: colors)
        vc.delegate = self
        return vc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.automaticallyUpdatesLighting = true
        sceneView.scene.rootNode.addChildNode(drawingController.baseNode)

        let light = SCNLight()
        light.type = .directional
        sceneView.pointOfView?.light = light

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingSessionConfiguration()
        configuration.isLightEstimationEnabled = true
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
        drawingController.clear()
        toggleOverlay(visible: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func reloadButtonpressed(_ sender: UIButton) {
        drawingController.clear()
    }

    @IBAction func colorSelectionButtonPressed(_ sender: UIButton) {
        colorSelectionViewController.modalPresentationStyle = .popover
        present(colorSelectionViewController, animated: true, completion: nil)
        let popoverController = colorSelectionViewController.popoverPresentationController!
        popoverController.sourceView = sender.superview
        popoverController.sourceRect = sender.frame
    }

    func toggleOverlay(visible: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.overlayView.isHidden = !visible
        }
    }

    // MARK: - ColorSelectionViewControllerDelegate
    func colorSelectionViewController(_ controller: ColorSelectionViewController, didSelectColor color: ColorSelectionViewController.ColorSelection) {
        drawingController.drawingColor = color.uiColor
        colorButton.tintColor = color.uiColor
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
        toggleOverlay(visible: true)
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        toggleOverlay(visible: false)
        
    }
}
