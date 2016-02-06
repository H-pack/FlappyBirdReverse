//
//  GameScene.swift
//  Flappy Birdk
//
//  Created by Hasaani Pack on 1/14/16.
//  Copyright (c) 2016 Hasaani. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var score = 0
    
    var scoreLabel = SKLabelNode()
    
    var gameOverLabel = SKLabelNode()
    
    var bird = SKSpriteNode()
    
    var bg = SKSpriteNode()
    
    var pipe1 = SKSpriteNode()
    
    var pipe2 = SKSpriteNode()
    
    var movingObjects = SKSpriteNode()
    
    var labelContainer = SKSpriteNode()
    
    enum colliderType: UInt32  {
    
        case Bird = 1
        case Object = 2
        case Gap = 4
    
    }
    
    var gameOver = false
    
    func makeBG() {
        
        
        let bgTexture = SKTexture(imageNamed: "bg.png")
        
        
        let movebg = SKAction.moveByX(bgTexture.size().width, y: 0, duration: 9)
        let replacebg = SKAction.moveByX(-bgTexture.size().width, y: 0, duration: 0)
        let movebgForever  = SKAction.repeatActionForever(SKAction.sequence( [movebg, replacebg]))
        
        
        
        
        for var i: CGFloat = 0; i<3; i++ {
            
            bg = SKSpriteNode(texture: bgTexture)
            
            bg.position = CGPoint(x: bgTexture.size().width/2 + bgTexture.size().width * -i, y: CGRectGetMidY(self.frame))
            
            bg.size.height = self.frame.height
            
            bg.zPosition = -1
            
            bg.runAction(movebgForever)
            
            movingObjects.addChild(bg)
            
        }
        
        
    }
    
    override func didMoveToView(view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        self.addChild(movingObjects)
        self.addChild(labelContainer)
        
        makeBG()
        
        scoreLabel.fontName = "Party LET"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height - 70)
        self.addChild(scoreLabel)
       
        let birdTexture = SKTexture(imageNamed: "flappy1.png")
        let birdTexture2 = SKTexture(imageNamed: "flappy2.png")
        
        let animation = SKAction.animateWithTextures([birdTexture, birdTexture2], timePerFrame: 0.3 )
        let makeBirdFlap = SKAction.repeatActionForever(animation)
        
        bird = SKSpriteNode(texture: birdTexture)
        
        bird.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        
        bird.runAction(makeBirdFlap)
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius:  birdTexture.size().height/2)
        bird.physicsBody!.dynamic = true
        
        bird.physicsBody!.categoryBitMask = colliderType.Bird.rawValue
        bird.physicsBody!.contactTestBitMask = colliderType.Object.rawValue
        bird.physicsBody!.collisionBitMask = colliderType.Object.rawValue
        
        self.addChild(bird)
        
        let ground = SKNode()
        ground.position = CGPointMake(0, 0)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, 1))
        ground.physicsBody!.dynamic = false
        
        ground.physicsBody!.categoryBitMask = colliderType.Object.rawValue
        ground.physicsBody!.contactTestBitMask = colliderType.Object.rawValue
        ground.physicsBody!.collisionBitMask = colliderType.Object.rawValue
        
        self.addChild(ground)
        
      
        
        _ = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("makePipes"), userInfo: nil, repeats: true)
        
    }
    
    
    func makePipes() {
        
        
        let gapHeight = bird.size.height * 4
        
        let moveAmount = arc4random() % UInt32(self.frame.size.height/2)
        
        let pipeOffSet = CGFloat(moveAmount) - self.frame.size.height/4
        
        let movePipes = SKAction.moveByX(self.frame.size.width * 2, y: 0, duration: NSTimeInterval(self.frame.width/100))
        let removePipes = SKAction.removeFromParent()
        let moveAndRemove = SKAction.sequence([movePipes, removePipes])
        
        
        let pipeTexture = SKTexture(imageNamed: "pipe1.png")
        let pipe1 = SKSpriteNode(texture: pipeTexture)
        pipe1.position = CGPoint(x: CGRectGetMidX(self.frame) - self.frame.size.width, y: CGRectGetMidY(self.frame) + pipeTexture.size().height/2 + gapHeight/2 + pipeOffSet)
        pipe1.runAction(moveAndRemove)
        
        pipe1.physicsBody = SKPhysicsBody(rectangleOfSize: pipeTexture.size())
        pipe1.physicsBody!.dynamic = false
        
        pipe1.physicsBody!.categoryBitMask = colliderType.Object.rawValue
        pipe1.physicsBody!.contactTestBitMask = colliderType.Object.rawValue
        pipe1.physicsBody!.collisionBitMask = colliderType.Object.rawValue
        
        movingObjects.addChild(pipe1)
        
        let pipeTexture2 = SKTexture(imageNamed: "pipe2.png")
        let pipe2 = SKSpriteNode(texture: pipeTexture2)
        pipe2.position = CGPoint(x: CGRectGetMidX(self.frame) - self.frame.size.width, y: CGRectGetMidY(self.frame) - pipeTexture2.size().height/2 - gapHeight/2 + pipeOffSet )
        pipe2.runAction(moveAndRemove)
        
        pipe2.physicsBody = SKPhysicsBody(rectangleOfSize: pipeTexture2.size())
        pipe2.physicsBody!.dynamic = false
        
        pipe2.physicsBody!.categoryBitMask = colliderType.Object.rawValue
        pipe2.physicsBody!.contactTestBitMask = colliderType.Object.rawValue
        pipe2.physicsBody!.collisionBitMask = colliderType.Object.rawValue
        
        movingObjects .addChild(pipe2)
        
        let gap = SKNode()
        gap.position = CGPoint(x: CGRectGetMidX(self.frame) - self.frame.size.width, y: CGRectGetMidX(self.frame) + pipeOffSet)
        gap.runAction(moveAndRemove)
        gap.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(pipe2.size.width/2, gapHeight))
        gap.physicsBody!.dynamic = false
        
        gap.physicsBody!.categoryBitMask = colliderType.Gap.rawValue
        gap.physicsBody!.contactTestBitMask = colliderType.Bird.rawValue
        gap.physicsBody!.collisionBitMask = colliderType.Gap.rawValue
        
        movingObjects .addChild(gap)
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask == colliderType.Gap.rawValue || contact.bodyB.categoryBitMask == colliderType.Gap.rawValue {
            
            score++
            
            scoreLabel.text = String(score)
            
        } else {
            
            if gameOver == false {
        
        gameOver = true
        
        self.speed = 0
        
        gameOverLabel.fontSize = 40
        gameOverLabel.fontName = "Party LET"
        gameOverLabel.text = "Nice Try! Tap to play again!"
        gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        labelContainer.addChild(gameOverLabel)
                
        }
            
            
        }
        
    }

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if gameOver == false {
            
            bird.physicsBody!.velocity = CGVectorMake(0, 0)
            bird.physicsBody!.applyImpulse(CGVectorMake(0, 50))
            
        } else {
            
            
            score = 0
            scoreLabel.text = "0"
            
            bird.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
            
            bird.physicsBody!.velocity = CGVectorMake(0, 0)
            
            movingObjects.removeAllChildren()
            
            makeBG()
            
            self.speed = 1
            
            gameOver = false
            
            labelContainer.removeAllChildren()
        }

       
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
