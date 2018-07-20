//
//  VaudevilleSpriteNodeButton.swift
//  Platformer
//
//  Created by Brandon Shien on 7/20/18.
//  Copyright © 2018 Brandon Shien. All rights reserved.
//

import SpriteKit

class VaudevilleSpriteNodeButton: SKSpriteNode {
    
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    func setup(){
        isUserInteractionEnabled = true
    }
    
    
    func touchDown(atPoint pos : CGPoint){
        alpha = 0.5
    }
    func touchMoved(atPoint pos : CGPoint){
        
    }
    func touchUp(atPoint pos : CGPoint){
        alpha = 1.0
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }

}
