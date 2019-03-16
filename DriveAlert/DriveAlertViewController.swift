//
//  ViewController.swift
//  DriveAlert
//
//  Created by Hadeel Elmadhoon on 2019-03-16.
//  Copyright © 2019 Hadeel Elmadhoon. All rights reserved.
//

import UIKit
import ARKit
import AVFoundation
import AudioToolbox


class DriveAlertViewController: UIViewController {

    static var count:Int = 0
    @IBOutlet var sceneView: ARSCNView!
    
    @IBAction func GoToGreen(_ sender: UIButton) {
        self.performSegue(withIdentifier: "StartBtn", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard ARFaceTrackingConfiguration.isSupported else {
            fatalError("Face tracking is not supported on this device")
        }
    
        sceneView.delegate = self
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 1
        let configuration = ARFaceTrackingConfiguration()
        
        // 2
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 1
        sceneView.session.pause()
    }
    
    func eyesClosed(from: ARFaceAnchor)->Bool {
        guard let eyeBlinkLeft = from.blendShapes[.eyeBlinkLeft], let eyeBlinkRight = from.blendShapes[.eyeBlinkRight] else {
            return false
        }
        // from testing: 0.5 is a lightish smile and 0.9 is an exagerrated smile
        return eyeBlinkLeft.floatValue >= 0.9 && eyeBlinkRight.floatValue >= 0.9
    }
    
    
}

// 1
extension DriveAlertViewController: ARSCNViewDelegate {
    // 2
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        // 3
        guard let device =  sceneView.device else {
            return nil
        }
        
        // 4
        let faceGeometry = ARSCNFaceGeometry(device: device)
        
        // 5
        let node = SCNNode(geometry: faceGeometry)
        
        // 6
        node.geometry?.firstMaterial?.fillMode = .lines
        
        // 7
        return node
    }
    
    // 1
    func renderer(
        _ renderer: SCNSceneRenderer,
        didUpdate node: SCNNode,
        for anchor: ARAnchor) {
        
        // 2
        guard let faceAnchor = anchor as? ARFaceAnchor,
            let faceGeometry = node.geometry as? ARSCNFaceGeometry else {
                return
        }
        
        // 3
        faceGeometry.update(from: faceAnchor.geometry)
        if eyesClosed(from: faceAnchor) == true{
            //print("closed!")
            DriveAlertViewController.count+=1
            //print( DriveAlertViewController.count)
        }
        else{
            DriveAlertViewController.count=0
            //green
        }
            
        if DriveAlertViewController.count>=175{
            AudioServicesPlaySystemSound(SystemSoundID(1304))
            
        }
//        var count: Int = 0
//        while eyesClosed(from: faceAnchor) == true{
//            count += 1
//        }
//        print(count)
    }
}
