//
//  ThreeDBarGraphView.swift
//  CommitCal
//
//  Created by apple on 3/1/24.
//

import SwiftUI
import SceneKit

struct ThreeDBarGraphView: View {
    let data: [ContributeData]
    let max: Int
    @State var viewWidth: CGFloat = 0
    var body: some View {
        SceneView(
            scene: GraghScene(data: data, max: max),
            options: [SceneView.Options.allowsCameraControl]
        )
    }
}

class GraghScene: SCNScene {
    var rowCount = 0
    
    convenience init(data: [ContributeData], max: Int) {
        self.init()
        background.contents = UIColor.background

        initBox(data: data, max: max)
        initFlow()
        initCamera()
    }
    
    func initFlow() {
        let flow = SCNBox(
            width: CGFloat(rowCount) + 1.1,
            height: 1,
            length: 7,
            chamferRadius: 0.0
        )
        
        let materials = [
            SCNMaterial(),
            SCNMaterial(),
            SCNMaterial(),
            SCNMaterial(),
            SCNMaterial(),
            SCNMaterial()
        ]
        
        materials[0].diffuse.contents = UIColor.boxLevel1Right
        materials[1].diffuse.contents = UIColor.boxLevel1Front
        materials[2].diffuse.contents = UIColor.boxLevel1Back
        materials[3].diffuse.contents = UIColor.boxLevel1Left
        materials[4].diffuse.contents = UIColor.boxLevel1Top
        materials[5].diffuse.contents = UIColor.boxLevel1Bottom
        
        flow.materials = materials
        
        let flowNode = SCNNode(geometry: flow)
        flowNode.position = SCNVector3(-0.5, -0.5, 3)
        self.rootNode.addChildNode(flowNode)
    }
    
    func initBox(data: [ContributeData], max: Int) {
        let cubeSize: CGFloat = 0.9
        
        print(data.count)
        print(data.count/7)
        print(Float(data.count).truncatingRemainder(dividingBy: 7))
        print(Float(data.count).truncatingRemainder(dividingBy: 7) == 0 ? 0 : 1)
        
        self.rowCount = data.count/7 + (Float(data.count).truncatingRemainder(dividingBy: 7) == 0 ? 0 : 1)
        
        for row in 0..<rowCount {
            for col in 0..<7 {
                if row*7+col >= data.count {
                    continue
                }
                
                var randomHeight = data[row*7+col].count
                if randomHeight == 0 {
                    continue
                }
                randomHeight = randomHeight*6/max+1
                let Height = CGFloat(randomHeight)
                
                let box = SCNBox(
                    width: cubeSize,
                    height: Height,
                    length: cubeSize,
                    chamferRadius: 0.0
                )
                let materials = [
                    SCNMaterial(),
                    SCNMaterial(),
                    SCNMaterial(),
                    SCNMaterial(),
                    SCNMaterial(),
                    SCNMaterial()
                ]
                
                if Height == 1 {
                    materials[0].diffuse.contents = UIColor.boxLevel1Right
                    materials[1].diffuse.contents = UIColor.boxLevel1Front
                    materials[2].diffuse.contents = UIColor.boxLevel1Back
                    materials[3].diffuse.contents = UIColor.boxLevel1Left
                    materials[4].diffuse.contents = UIColor.boxLevel1Top
                    materials[5].diffuse.contents = UIColor.boxLevel1Bottom
                } else if Height == 2 {
                    materials[0].diffuse.contents = UIColor.boxLevel2Right
                    materials[1].diffuse.contents = UIColor.boxLevel2Front
                    materials[2].diffuse.contents = UIColor.boxLevel2Back
                    materials[3].diffuse.contents = UIColor.boxLevel2Left
                    materials[4].diffuse.contents = UIColor.boxLevel2Top
                    materials[5].diffuse.contents = UIColor.boxLevel2Bottom
                } else if Height == 3 {
                    materials[0].diffuse.contents = UIColor.boxLevel3Right
                    materials[1].diffuse.contents = UIColor.boxLevel3Front
                    materials[2].diffuse.contents = UIColor.boxLevel3Back
                    materials[3].diffuse.contents = UIColor.boxLevel3Left
                    materials[4].diffuse.contents = UIColor.boxLevel3Top
                    materials[5].diffuse.contents = UIColor.boxLevel3Bottom
                } else if Height == 4 {
                    materials[0].diffuse.contents = UIColor.boxLevel4Right
                    materials[1].diffuse.contents = UIColor.boxLevel4Front
                    materials[2].diffuse.contents = UIColor.boxLevel4Back
                    materials[3].diffuse.contents = UIColor.boxLevel4Left
                    materials[4].diffuse.contents = UIColor.boxLevel4Top
                    materials[5].diffuse.contents = UIColor.boxLevel4Bottom
                } else if Height == 5 {
                    materials[0].diffuse.contents = UIColor.boxLevel5Right
                    materials[1].diffuse.contents = UIColor.boxLevel5Front
                    materials[2].diffuse.contents = UIColor.boxLevel5Back
                    materials[3].diffuse.contents = UIColor.boxLevel5Left
                    materials[4].diffuse.contents = UIColor.boxLevel5Top
                    materials[5].diffuse.contents = UIColor.boxLevel5Bottom
                } else {
                    materials[0].diffuse.contents = UIColor.boxLevel6Right
                    materials[1].diffuse.contents = UIColor.boxLevel6Front
                    materials[2].diffuse.contents = UIColor.boxLevel6Back
                    materials[3].diffuse.contents = UIColor.boxLevel6Left
                    materials[4].diffuse.contents = UIColor.boxLevel6Top
                    materials[5].diffuse.contents = UIColor.boxLevel6Bottom
                }
                
                box.materials = materials
                
                let cubeNode = SCNNode(geometry: box)
                cubeNode.position = SCNVector3(
                    Float(row - 26),
                    Float(Height)/2,
                    Float(col)
                )
                self.rootNode.addChildNode(cubeNode)
            }
        }
    }
    
    func initCamera() {
        let camera = SCNCamera()
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(0, 10, 55)
        
        self.rootNode.addChildNode(cameraNode)
    }
}

#Preview {
    ThreeDBarGraphView(data: MainViewModel.dummyStreak, max: MainViewModel.dummyStreak.map{$0.count}.max()!)
}
