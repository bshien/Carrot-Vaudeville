//
//  level1.swift
//  Platformer
//
//  Created by Brandon Shien on 7/17/18.
//  Copyright © 2018 Brandon Shien. All rights reserved.
//


import SpriteKit
import GameplayKit


class level1: SKScene, VaudevilleSpriteNodeButtonDelegate {
    var jumpButton: VaudevilleSpriteNodeButton!
    var leftButton: VaudevilleSpriteNodeButton!
    var rightButton: VaudevilleSpriteNodeButton!
    var cam: SKCameraNode?
    
    override func didMove(to: SKView){
        jumpButton = childNode(withName: "jumpButton") as! VaudevilleSpriteNodeButton
        jumpButton.delegate = self
        leftButton = childNode(withName: "leftButton") as! VaudevilleSpriteNodeButton
        leftButton.delegate = self
        rightButton = childNode(withName: "rightButton") as! VaudevilleSpriteNodeButton
        rightButton.delegate = self
        super.didMove(to: view!)
        cam = SKCameraNode()
        self.camera = cam
        self.addChild(cam!)
        
        
        
    }
    
    override func update(_ currentTime: TimeInterval){
        let skele = self.childNode(withName: "skele")
        let skelePos = skele?.position
    //called before each frame is rendered
        let jumpUp = SKAction.moveBy(x:0, y: 10, duration: 0.2)
       
        if (jumpButton.state == .down){
            
            skele?.run(jumpUp)
            
        }
        if leftButton.state == .down{
            skele?.position.x -= 5
        }
        if rightButton.state == .down{
            skele?.position.x += 5
        }
        super.update(currentTime)
        if let camera = cam, let pl = skele {
            camera.position = pl.position
        }
       
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
    
    func jump(){
        
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
    
    
    func spriteButtonDown(_ button: VaudevilleSpriteNodeButton){
        print("spriteButtonDown")
    }
    func spriteButtonUp(_ button: VaudevilleSpriteNodeButton){
        print("spriteButtonUp")
    }
    func spriteButtonMoved(_ button: VaudevilleSpriteNodeButton){
        print("spriteButtonMoved")
    }
    func spriteButtonTapped(_ button: VaudevilleSpriteNodeButton){
        print("spriteButtonTapped")
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
