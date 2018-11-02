//
//  level2.swift
//  Platformer
//
//  Created by Brandon Shien on 8/9/18.
//  Copyright © 2018 Brandon Shien. All rights reserved.
//


import SpriteKit
import GameplayKit
import UIKit


class level2: SKScene, VaudevilleSpriteNodeButtonDelegate, SKPhysicsContactDelegate {
    var jumpButton: VaudevilleSpriteNodeButton!
    var leftButton: VaudevilleSpriteNodeButton!
    var rightButton: VaudevilleSpriteNodeButton!
    var cam: SKCameraNode?
    var backgroundlvltwo: SKSpriteNode!
    let carrotCategory: UInt32 = 0x1 << 0
    let ghostCategory: UInt32 = 0x1 << 1
    let skeleCategory: UInt32 = 0x1 << 2
    var contactQueue2 = [SKPhysicsContact]()
    var slime1: SKSpriteNode!
    var snakeKing: SKSpriteNode!
    var snakeKingHP = 50
    
    
    //moving block stuff
    var movingBlock1: SKSpriteNode!
    //original pos
    var movingBlock1Up = 1
    var movingBlock1posy: Float = 0.0
    
    var movingBlock2: SKSpriteNode!
    
    
    
    
    override func didMove(to: SKView){
        
        jumpButton = childNode(withName: "jumpButton") as? VaudevilleSpriteNodeButton
        jumpButton.delegate = self
        leftButton = childNode(withName: "leftButton") as? VaudevilleSpriteNodeButton
        leftButton.delegate = self
        rightButton = childNode(withName: "rightButton") as? VaudevilleSpriteNodeButton
        rightButton.delegate = self
        super.didMove(to: view!)
        cam = SKCameraNode()
        self.camera = cam
        self.addChild(cam!)
        backgroundlvltwo = childNode(withName: "backgroundlvltwo") as? SKSpriteNode
        
        
       
            
        
        //moving block stuff
        movingBlock1 = childNode(withName: "movingBlock1") as? SKSpriteNode
        movingBlock1posy = Float(movingBlock1.position.y)
        movingBlock2 = childNode(withName: "movingBlock2") as? SKSpriteNode
     
        
        /*
        snakeKing = childNode(withName: "snakeKing") as! SKSpriteNode
        snakeKing.physicsBody?.categoryBitMask = ghostCategory
        
        snakeKing.physicsBody?.contactTestBitMask = skeleCategory
 */
        
        physicsWorld.contactDelegate = self
        
        
        
    }
    
    override func update(_ currentTime: TimeInterval){
        /*
        if self.childNode(withName: "snakeKing") == nil {
            let leveltwo = level2(fileNamed: "level2")
            self.view?.presentScene(leveltwo)
        }
        */
        
      
        
        
        //moving block stuff
        if movingBlock1.position.y > CGFloat(movingBlock1posy) + 300 {
            movingBlock1Up = -1
        }
        if movingBlock1.position.y < CGFloat(movingBlock1posy) {
            movingBlock1Up = 1
        }
        movingBlock1.position.y += CGFloat(3 * movingBlock1Up)
        
        movingBlock2.position.y += CGFloat(3 * (movingBlock1Up * -1))
        
        
        
        
        
        
        
        if self.childNode(withName: "slime") != nil {
            slime1 = childNode(withName: "slime") as? SKSpriteNode
            slime1.physicsBody?.categoryBitMask = ghostCategory
            slime1.physicsBody?.collisionBitMask = 1
            slime1.physicsBody?.contactTestBitMask = skeleCategory
        }
        let skele = self.childNode(withName: "skele")
        skele?.physicsBody?.categoryBitMask = skeleCategory
        
        
        print(skele?.position ?? "default value")
        
        if (skele?.position.y)! < CGFloat(-1000) {
            let carrotMenu = GameScene(fileNamed: "GameScene")
            self.view?.presentScene(carrotMenu)
        }
        
        
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
        if let jumpBtn = jumpButton, let pl = skele {
            jumpBtn.position = CGPoint(x: pl.position.x + 300,y: pl.position.y - 150)
            
        }
        if let leftBtn = leftButton, let pl = skele {
            leftBtn.position = CGPoint(x: pl.position.x - 300,y: pl.position.y - 150)
            
        }
        if let rightBtn = rightButton, let pl = skele {
            rightBtn.position = CGPoint(x: pl.position.x - 200,y: pl.position.y - 150)
            
        }
        if let background = backgroundlvltwo, let pl = skele {
            background.position = CGPoint(x: pl.position.x,y: pl.position.y)
            
        }
        if let slime = slime1, let pl = skele {
            if slime.position.x - pl.position.x < (size.width/2) {
                slime.physicsBody?.velocity = CGVector(dx: -100, dy:0)
            }
        }
        
        if let snakeKing = snakeKing, let pl = skele {
            if snakeKing.position.x - pl.position.x < (size.width/2) {
                snakeKing.physicsBody?.velocity = CGVector(dx: -100, dy:0)
            }
            
            if snakeKingHP == 0 {
                snakeKing.removeFromParent()
            }
            
        }
        
        
        
        if self.childNode(withName: "ghostNode") == nil {
            let ghost = SKSpriteNode(imageNamed: "ghost.png")
            ghost.position = CGPoint(x: (skele?.position.x)! + 600, y: (skele?.position.y)!)
            ghost.name = "ghostNode"
            ghost.physicsBody = SKPhysicsBody(rectangleOf: ghost.frame.size)
            ghost.physicsBody?.isDynamic = true
            ghost.physicsBody?.affectedByGravity = false
            ghost.physicsBody?.velocity = CGVector(dx: -100, dy:0)
            
            ghost.physicsBody?.usesPreciseCollisionDetection = true
            ghost.physicsBody?.categoryBitMask = ghostCategory
            ghost.physicsBody?.collisionBitMask = 0
            ghost.physicsBody?.contactTestBitMask = skeleCategory
            
            //self.addChild(ghost)
        }
        
        processContacts(forUpdate: currentTime)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let skele = self.childNode(withName: "skele")
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let xpos = touchLocation.x
        let ypos = touchLocation.y
        var forward: CGFloat  = 1
        
        if xpos<(skele?.position.x)! {
            forward = -1
        }
        
        let shootBullet = SKAction.run({
            let bulletNode = self.createBullet(forward: forward)
            self.addChild(bulletNode)
            
            let moveUpAction = SKAction.moveBy(x: (xpos - (skele?.position.x)!) * 10 , y: (ypos - (skele?.position.y)!) * 10 , duration: 2.0)
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
        contactQueue2.append(contact)
        
    }
    
    func handle(_ contact: SKPhysicsContact){
        if contact.bodyA.node?.parent == nil || contact.bodyB.node?.parent == nil{
            return
        }
        let nodeNames = [contact.bodyA.node!.name, contact.bodyB.node!.name]
        if nodeNames.contains("bulletNode") && (nodeNames.contains("ghostNode") || nodeNames.contains("slime")) {
            //carrot hits ghost
            contact.bodyA.node!.removeFromParent()
            contact.bodyB.node!.removeFromParent()
        }
            
        else if nodeNames.contains("skele") && (nodeNames.contains("ghostNode") || nodeNames.contains("slime") || nodeNames.contains("snakeKing") ){
            //skele hits ghost
            let carrotMenu = GameScene(fileNamed: "GameScene")
            self.view?.presentScene(carrotMenu)
        }
        else if nodeNames.contains("bulletNode") && nodeNames.contains("snakeKing") {
            if (contact.bodyA.node!.name?.contains("bulletNode"))!{
                contact.bodyA.node!.removeFromParent()
            }
            else{
                contact.bodyB.node!.removeFromParent()
            }
            snakeKingHP -= 1
        }
    }
    
    
    func processContacts(forUpdate currentTime: CFTimeInterval){
        for contact in contactQueue2{
            handle(contact)
            
            if let index = contactQueue2.index(of: contact){
                contactQueue2.remove(at: index)
            }
        }
    }
    
    
    
    
    
    
    func createBullet(forward: CGFloat) -> SKSpriteNode {
        let skele = self.childNode(withName: "skele")
        let skelePos = skele?.position
        let skeleWidth = skele?.frame.size.width
        let bullet = SKSpriteNode(imageNamed: "carrot.png")
        bullet.position = CGPoint(x: skelePos!.x + (skeleWidth!/2 + bullet.frame.size.width/2) * forward, y: skelePos!.y)
        bullet.name = "bulletNode"
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.frame.size)
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        bullet.physicsBody?.categoryBitMask = carrotCategory
        bullet.physicsBody?.contactTestBitMask = ghostCategory
        bullet.physicsBody?.affectedByGravity = false
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
