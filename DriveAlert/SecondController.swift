//
//  SecondController.swift
//  DriveAlert
//
//  Created by Hadeel Elmadhoon on 2019-03-16.
//  Copyright © 2019 Hadeel Elmadhoon. All rights reserved.
//

import UIKit
import ARKit
import AVFoundation
import AudioToolbox


class SecondController: UIViewController {
    
    static var count:Int = 0
    
    
    
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
extension SecondController: ARSCNViewDelegate {
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
        if eyesClosed(from: faceAnchor) == true ||  SecondController.started == true{
            //print("closed!")
            SecondController.count+=1
            //print( DriveAlertViewController.count)
        }
        else{
            SecondController.count=0
            //green
        }
        
        if SecondController.count>=175 {
            AudioServicesPlaySystemSound(SystemSoundID(1304))
            
        }
        //        var count: Int = 0
        //        while eyesClosed(from: faceAnchor) == true{
        //            count += 1
        //        }
        //        print(count)
    }
}
