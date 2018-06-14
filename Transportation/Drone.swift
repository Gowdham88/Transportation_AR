//
//  Drone.swift
//  Transportation
//
//  Created by CZSM4 on 17/05/18.
//  Copyright © 2018 CZSM2. All rights reserved.
//
import ARKit

class Drone: SCNNode {
    func loadModel() {
        guard let virtualObjectScene = SCNScene(named: "newCar.scn") else { return }
        let wrapperNode = SCNNode()
        for child in virtualObjectScene.rootNode.childNodes {
            wrapperNode.addChildNode(child)
        }
        addChildNode(wrapperNode)
    }
}
