//
//  GameScene.swift
//  LufY
//
//  Created by Ahmed Sabir on 18/11/1441 AH.
//  Copyright © 1441 Ahmed Sabir. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene
{
    //MARK:- Properties
     private var dotNode : SKSpriteNode = SKSpriteNode(imageNamed: "dot-3")
    private var lineNode : SKSpriteNode = SKSpriteNode(imageNamed: "line1")
      private var lineV1Node : SKSpriteNode = SKSpriteNode(imageNamed: "lineV1")
    let playableRect: CGRect
    var lastUpdateTime: TimeInterval = 0
    let dotMovePointsPerSec: CGFloat = 480.0
     var dt:TimeInterval = 0.0
    var velocity = CGPoint.zero
    var lastTouchLocation: CGPoint?
    override init(size: CGSize)
        {
          let maxAspectRatio:CGFloat = 16.0/9.0 // 1
          let playableHeight = size.width / maxAspectRatio // 2
          let playableMargin = (size.height-playableHeight)/2.0 // 3
          playableRect = CGRect(x: 0, y: playableMargin,
                                width: size.width,
                                height: playableHeight) // 4
 
          super.init(size: size)
            
 
         }

        required init(coder aDecoder: NSCoder) {
          fatalError("init(coder:) has not been implemented") // 6
        }
    
    //MARK:- didMove & Update methods
    override func didMove(to view: SKView)
    {
        self.lineV1Node.position = CGPoint(x: 700, y: 800)
        self.lineNode.position = CGPoint(x: 700, y: 600)
         self.dotNode.position = CGPoint(x: 400, y: 600)
        addChild(lineV1Node)
        addChild(lineNode)
         addChild(dotNode)
        debugDrawPlayableArea()
    }
 
    
    override func update(_ currentTime: TimeInterval)
    {
        if lastUpdateTime > 0
        {
            dt = currentTime - lastUpdateTime
        } else
        {
            dt = 0
        }
        lastUpdateTime = currentTime
        if let lastTouchLocation = lastTouchLocation
           {
             let diff = lastTouchLocation - dotNode.position
            print("differince = \(diff)")
            print("diffe.length = \(diff.length())")
             print("dotmovprsec*dt = \(dotMovePointsPerSec * CGFloat(dt))")
            
             if diff.length() <= dotMovePointsPerSec * CGFloat(dt)
             {
               dotNode.position = lastTouchLocation
               velocity = CGPoint.zero
             } else {
               move(sprite: dotNode, velocity: velocity)
              }
//        boundsCheckDot()
//
//
        }
        
    }
    
    func moveDotToward(location: CGPoint)
        {
             let offset = location - dotNode.position

             let length = sqrt(
              Double(offset.x * offset.x + offset.y * offset.y))

            let direction = CGPoint(x: offset.x / CGFloat(length),
                                    y: offset.y / CGFloat(length))

            velocity = direction * dotMovePointsPerSec
         
         
            move(sprite: dotNode, velocity: velocity)

           }
    
    func move(sprite: SKSpriteNode, velocity: CGPoint)
    {
         let amountToMove = velocity * CGFloat(dt)
        sprite.position += amountToMove
 
      }
    
    func sceneTouched(touchLocation:CGPoint)
       {
           lastTouchLocation = touchLocation
          moveDotToward(location: touchLocation)
       }
    override func touchesBegan(_ touches: Set<UITouch>,
          with event: UIEvent?) {
        guard let touch = touches.first else {
          return
        }
        let touchLocation = touch.location(in: self)
        sceneTouched(touchLocation: touchLocation)
      }
    override func didEvaluateActions() {
//      checkCollisions()
    }
    
    func debugDrawPlayableArea() {
      let shape = SKShapeNode(rect: playableRect)
      shape.strokeColor = SKColor.red
      shape.lineWidth = 4.0
      addChild(shape)
    }
    
    func dotHit(line: SKSpriteNode)
       {
        dotNode.position = line.position
       }
   
     func boundsCheckDot()
    {
        if let lastTouchLocation = lastTouchLocation {
            dotNode.position = lastTouchLocation
            velocity = CGPoint.zero

        }
        else  {
             move(sprite: dotNode, velocity: velocity)
        }
        //move(sprite: dotNode, velocity: velocity)
//        let topRight = CGPoint(x: lineV1Node.position.x, y: lineV1Node.position.y)
//
//        if dotNode.position.x >= topRight.x
//        {
//            dotNode.zPosition = 100
//            dotNode.position.x = topRight.x
//            velocity.x = 0
//        }
//
//        if dotNode.position.y >= topRight.y {
//            dotNode.zPosition = 50
//            dotNode.position.y = topRight.y
//            velocity.y = 0
//        }
    }
}
