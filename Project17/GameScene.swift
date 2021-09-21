//
//  GameScene.swift
//  Project17
//
//  Created by othman shahrouri on 9/20/21.
//
//advanceSimulationTime()
//most of the screen wouldn't start with particles and they would just stream in from the right. But by using the advanceSimulationTime() method of the emitter we’re going to ask SpriteKit to simulate 10 seconds passing in the emitter, thus updating all the particles as if they were created 10 seconds ago
//-------------------------------------------------------------------------------------

//Irregular shapes use per-pixel collision detection
import SpriteKit
import GameplayKit

class GameScene: SKScene , SKPhysicsContactDelegate{
    var starField: SKEmitterNode!
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        starField = SKEmitterNode(fileNamed: "starfield")!
       //right edge of the screen and half way up
        starField.position = CGPoint(x: 1024, y: 384)
        starField.advanceSimulationTime(10)
        starField.zPosition = -1
        addChild(starField)
       
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        //Creates physics body from player texture
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        //which contact we care about
        //1 means other things in our game the things are inclined with
        //set the contact test bit mask for our player to be 1. This will match the category bit mask we will set for space debris later on, and it means that we'll be notified when the player collides with debris
        //determines which collisions are reported to us
        player.physicsBody?.contactTestBitMask = 1
      
        addChild(player)
       
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        score = 0
        
        //bec we are in space
        physicsWorld.gravity = .zero
        // sets our current game scene to be the contact delegate of the physics world
        physicsWorld.contactDelegate = self
        
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
