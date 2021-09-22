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

//----------------------------------------------------------------------------------
//Timer is responsible for running code after a period of time has passed, either once or repeatedly
//Parameters:
//seconds to delay, object to tell when it has fired,  what method should be called, any context you want to provide, and whether the time should repeat
//--------------------------------------------------------------------------------------
//linearDamping and angularDamping by default have values > 0 to stimulate friction in the air

import SpriteKit
import GameplayKit

class GameScene: SKScene , SKPhysicsContactDelegate{
    var starField: SKEmitterNode!
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    
    var possibleEnimies = ["ball", "hammer", "tv"]
    var gameTimer: Timer?
    var isGameOver = false
    
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
        addChild(starField)
        starField.zPosition = -1
    
       
        
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
        
        //ScheduledTimer() timer not only creates a timer, but also starts it immediately.
        gameTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        
        //linearDamping = 0 and angular  movement and rotation will never slow down over time perfect for frictionless environement
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        for node in children {
            //removing nodes whenever the node passed -300
            if node.position.x < -300 {
                node.removeFromParent()
            }
            //update score
            if !isGameOver {
                score += 1
            }
        }
    }
    
    
    
    //MARK: - Player Movement
     override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)
        //dont go below that point,near score label
        if location.y < 100 {
            location.y = 100
        }
        //dont go above that point
        else if location.y > 668 {
            location.y = 668
        }
        //move the player whenever they move their touch
        player.position = location
    }
    
    
    //MARK: - Collision with player
    func didBegin(_ contact: SKPhysicsContact) {
        if let explosion = SKEmitterNode(fileNamed: "explosion") {
            explosion.position = player.position
            addChild(explosion)
        }
        player.removeFromParent()
        isGameOver = true
    }
    
    
    
    
    //MARK: - Create Enemy
    
    @objc func createEnemy() {
        guard let enemy = possibleEnimies.randomElement() else { return }
        
        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
        addChild(sprite)
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        //let it collide with the player
        sprite.physicsBody?.contactTestBitMask = 1
        //speed when moving/giving it a push
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        //Spin it in the air,give it constant spin
        sprite.physicsBody?.angularVelocity = 5
        //controls how fast things slows down over time/never slow it down
        sprite.physicsBody?.linearDamping = 0
        //never stops spining
        sprite.physicsBody?.angularDamping = 0
        
   
    }
    
}
