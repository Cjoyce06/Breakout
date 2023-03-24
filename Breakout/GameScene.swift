//
//  GameScene.swift
//  Breakout
//
//  Created by Colin Joyce on 3/18/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var ball = SKShapeNode()
    var brick = SKSpriteNode()
    var loseZone = SKSpriteNode()
    var paddle = SKSpriteNode()
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        createBackround()
        resetGame()
        makeLoseZone()
        kickBall()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            paddle.position.x = location.x
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            paddle.position.x = location.x
        }
    }
    
    func resetGame() {
        // this stuff happens before each game starts
        makeBall()
        makeBrick()
        makePaddle()
    }
     
    func kickBall() {
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.applyImpulse(CGVector(dx: 3, dy: 5))
    }
    
    func createBackround() {
        let stars = SKTexture(imageNamed: "Stars")
        for i in 0...1{
            let starsBackround = SKSpriteNode(texture: stars)
            starsBackround.zPosition = -1
            starsBackround.position = CGPoint(x: 0, y: starsBackround.size.height * CGFloat(i))
            addChild(starsBackround)
            let moveDown = SKAction.moveBy(x: 0, y: -starsBackround.size.height, duration: 20)
            let moveReset = SKAction.moveBy(x: 0, y: starsBackround.size.height, duration: 0)
            let moveLoop = SKAction.sequence([moveDown, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            starsBackround.run(moveForever)
        }
    }
    func makeBall() {
        ball.removeFromParent() // remover the ball (if it exists)
        ball = SKShapeNode(circleOfRadius: 10)
        ball.position = CGPoint(x: frame.midX, y: frame.midY)
        ball.strokeColor = .black
        ball.fillColor = .yellow
        ball.name = "Ball"
        
        // physics shape matches ball image
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        // ignores all forces and impulses
        ball.physicsBody?.isDynamic = false
        // use precise collision detection
        ball.physicsBody?.usesPreciseCollisionDetection = true
        // no loss of energy from friction
        ball.physicsBody?.friction = 0
        // gravity is not a factor
        ball.physicsBody?.affectedByGravity = false
        // bounces fully off of other objects
        ball.physicsBody?.restitution = 1
        // does not slow down over time
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.contactTestBitMask = (ball.physicsBody?.collisionBitMask)!
        
        addChild(ball) // add ball object to the view
    }
    
    func makeBrick() {
        brick.removeFromParent() // remove the brick if it exists
        brick = SKSpriteNode(color: .blue, size: CGSize(width: 50, height: 20))
        brick.position = CGPoint(x: frame.midX, y: frame.maxY - 50)
        brick.name = "Brick"
        brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
        brick.physicsBody?.isDynamic = false
        addChild(brick)
    }
    
    func makeLoseZone() {
        loseZone = SKSpriteNode(color: .red, size: CGSize(width: frame.width, height: 50))
        loseZone.position = CGPoint(x: frame.midX, y: frame.minY + 25)
        loseZone.name = "loseZone"
        loseZone.physicsBody = SKPhysicsBody(rectangleOf: loseZone.size)
        loseZone.physicsBody?.isDynamic = false
        addChild(loseZone)
    }
    
    func makePaddle() {
        paddle.removeFromParent()
        paddle = SKSpriteNode(color: .white, size: CGSize(width: frame.width/4, height: 20))
        paddle.position = CGPoint(x: frame.midX, y: frame.minY + 125)
        paddle.name = "paddle"
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.size)
        paddle.physicsBody?.isDynamic = false
        addChild(paddle)
    }
}
