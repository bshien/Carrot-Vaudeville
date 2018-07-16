//
//  GameScene.swift
//  Platformer
//
//  Created by Brandon Shien on 7/15/18.
//  Copyright © 2018 Brandon Shien. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    

    
    override func didMove(to view: SKView) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let carrotMenu = childNode(withName: "carrotMenu")
        
        if(carrotMenu != nil){
            let fadeOut = SKAction.fadeOut(withDuration: 1.0)
            
            carrotMenu?.run(fadeOut, completion: {
                let overworld = Overworld(fileNamed: "Overworld")
                self.view?.presentScene(overworld)
            })
        }
        }
        
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
