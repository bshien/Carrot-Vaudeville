//
//  VaudevilleSpriteNodeButton.swift
//  Platformer
//
//  Created by Brandon Shien on 7/20/18.
//  Copyright © 2018 Brandon Shien. All rights reserved.
//

import SpriteKit

protocol VaudevilleSpriteNodeButtonDelegate: class {
    func spriteButtonDown(_ button: VaudevilleSpriteNodeButton)
    func spriteButtonUp(_ button: VaudevilleSpriteNodeButton)
    func spriteButtonMoved(_ button: VaudevilleSpriteNodeButton)
    func spriteButtonTapped(_ button: VaudevilleSpriteNodeButton)
}

class VaudevilleSpriteNodeButton: SKSpriteNode {
    
    enum SpriteButtonState{
        case up
        case down
    }
    
    weak var delegate: VaudevilleSpriteNodeButtonDelegate?
    var label: SKLabelNode?
    
    var state = SpriteButtonState.up
    
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
        
        for child in children{
            if let label = child as? SKLabelNode{
                self.label = label
            }
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint){
        alpha = 0.5
        state = .down
        delegate?.spriteButtonDown(self)
    }
    func touchMoved(atPoint pos : CGPoint){
        delegate?.spriteButtonMoved(self)
    }
    func touchUp(atPoint pos : CGPoint){
        alpha = 1.0
        state = .up
        delegate?.spriteButtonUp(self)
        
        if contains(pos){
            delegate?.spriteButtonTapped(self)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(atPoint: t.location(in: self)) }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            if parent != nil{
            self.touchUp(atPoint: t.location(in: self))
            }
            }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            if parent != nil{
                self.touchUp(atPoint: t.location(in: self))
            }
        }
    }

}
