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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let skele = self.childNode(withName: "skele")
        let shootBullet = SKAction.run({
            let bulletNode = self.createBullet()
            self.addChild(bulletNode)
            bulletNode.physicsBody?.applyImpulse(CGVector(dx: 160.0, dy: 0))
        })
        
        skele?.run(shootBullet)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func createBullet() -> SKSpriteNode {
    let skele = self.childNode(withName: "skele")
    let skelePos = skele?.position
    let skeleWidth = skele?.frame.size.width
    let bullet = SKSpriteNode(imageNamed: "carrot.png")
        bullet.position = CGPoint(x: skelePos!.x + skeleWidth!/2, y: skelePos!.y)
        bullet.name = "bulletNode"
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.frame.size)
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        
        return bullet
        
    }
}
