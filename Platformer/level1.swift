//
//  level1.swift
//  Platformer
//
//  Created by Brandon Shien on 7/17/18.
//  Copyright © 2018 Brandon Shien. All rights reserved.
//


import SpriteKit
import GameplayKit
import UIKit


class level1: SKScene, VaudevilleSpriteNodeButtonDelegate, SKPhysicsContactDelegate {
    var jumpButton: VaudevilleSpriteNodeButton!
    var leftButton: VaudevilleSpriteNodeButton!
    var rightButton: VaudevilleSpriteNodeButton!
    var cam: SKCameraNode?
    let carrotCategory: UInt32 = 0x1 << 0
    let ghostCategory: UInt32 = 0x1 << 1
    let skeleCategory: UInt32 = 0x1 << 2
    var contactQueue = [SKPhysicsContact]()
    
    
    
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
        cam?.addChild(jumpButton)
        cam?.addChild(leftButton)
        cam?.addChild(rightButton)

        physicsWorld.contactDelegate = self
        
        
        
    }
    
    override func update(_ currentTime: TimeInterval){
        let skele = self.childNode(withName: "skele")
        skele?.physicsBody?.categoryBitMask = skeleCategory
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
        if self.childNode(withName: "ghostNode") == nil {
            let ghost = SKSpriteNode(imageNamed: "ghost.png")
            ghost.position = CGPoint(x: size.width, y: (skele?.position.y)!)
            ghost.name = "ghostNode"
            ghost.physicsBody = SKPhysicsBody(rectangleOf: ghost.frame.size)
            ghost.physicsBody?.isDynamic = true
            ghost.physicsBody?.affectedByGravity = false
            ghost.physicsBody?.velocity = CGVector(dx: -100, dy:0)
            
            ghost.physicsBody?.usesPreciseCollisionDetection = true
            ghost.physicsBody?.categoryBitMask = ghostCategory
            ghost.physicsBody?.collisionBitMask = 0
            ghost.physicsBody?.contactTestBitMask = skeleCategory
            
            self.addChild(ghost)
        }
        processContacts(forUpdate: currentTime)
       
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
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        contactQueue.append(contact)
        
    }
    
    func handle(_ contact: SKPhysicsContact){
        if contact.bodyA.node?.parent == nil || contact.bodyB.node?.parent == nil{
            return
        }
        let nodeNames = [contact.bodyA.node!.name, contact.bodyB.node!.name!]
        if nodeNames.contains("bulletNode") && nodeNames.contains("ghostNode") {
            //carrot hits ghost
            contact.bodyA.node!.removeFromParent()
            contact.bodyB.node!.removeFromParent()
        }
        
        else if nodeNames.contains("skele") && nodeNames.contains("ghostNode") {
            //skele hits ghost
            let carrotMenu = GameScene(fileNamed: "GameScene")
            self.view?.presentScene(carrotMenu)
        }
    }
    
    
    func processContacts(forUpdate currentTime: CFTimeInterval){
        for contact in contactQueue{
            handle(contact)
        
        if let index = contactQueue.index(of: contact){
            contactQueue.remove(at: index)
        }
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
        bullet.physicsBody?.categoryBitMask = carrotCategory
        bullet.physicsBody?.contactTestBitMask = ghostCategory
        bullet.physicsBody?.collisionBitMask = 0
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
