//
//  level1.swift
//  Platformer
//
//  Created by Brandon Shien on 7/17/18.
//  Copyright © 2018 Brandon Shien. All rights reserved.
//

import UIKit
import SpriteKit

class level1: SKScene {
    override func didMove(to: SKView){
     
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let xpos = touchLocation.x
        let ypos = touchLocation.y
        var forward: CGFloat  = 1
        
        if xpos<0 {
            forward = -1
        }
        let skele = self.childNode(withName: "skele")
        let shootBullet = SKAction.run({
            let bulletNode = self.createBullet(forward: forward)
            self.addChild(bulletNode)
          
            let moveUpAction = SKAction.moveBy(x: xpos * 10, y: ypos * 10, duration: 2.0)
            let destroy = SKAction.removeFromParent()
            let sequence = SKAction.sequence([moveUpAction, destroy])
            bulletNode.run(sequence)
            
        })
        
        
        
        
        skele?.run(shootBullet)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in touches{
            
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func createBullet(forward: CGFloat) -> SKSpriteNode {
    let skele = self.childNode(withName: "skele")
    let skelePos = skele?.position
    let skeleWidth = skele?.frame.size.width
    let bullet = SKSpriteNode(imageNamed: "carrot.png")
        bullet.position = CGPoint(x: skelePos!.x + (skeleWidth!/2) * forward, y: skelePos!.y)
        bullet.name = "bulletNode"
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.frame.size)
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        
        return bullet
        
    }
}
