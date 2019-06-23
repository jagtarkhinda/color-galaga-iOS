//
//  GameScene.swift
//  Galaga
//
//  Created by Harsh Parikh on 2019-06-19.
//  Copyright © 2019 Pranav Patel. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Variables for images
    let background = SKSpriteNode(imageNamed: "background")
    let background2 = SKSpriteNode(imageNamed: "background")
    var player = SKSpriteNode(imageNamed: "jet")
    var moveUFO:SKSpriteNode!
    var timeBomb:SKSpriteNode?
    var scoreLabel: SKLabelNode!
    var timeLabel: SKLabelNode!
    var remainingLife = 3
    var UFOCount = 0;
    var UFODown = 0
    var AIRCRAFTCount = 0;
    var remainingLifeNode:[SKSpriteNode] = []
    var decreaseLivescount:Bool = false;
    var timeLeft = 119
    // variable to store scores
    var socreCount:Int = 0;
    var PLspeed: CGFloat = 0
    
    // Enemy
    var ufos:[SKSpriteNode] = []
    var aircrafts:[SKSpriteNode] = []
    var shuttles:[SKSpriteNode] = []
    
    //showing remaining live on bottom right of screen
    func makeremainingLife(imgWidth:CGFloat) {
        // lets add some cats
        let life = SKSpriteNode(imageNamed: "jet")
        life.anchorPoint = CGPoint(x: 0, y: 0)
        life.position = CGPoint(x:(self.size.width - (life.size.width * imgWidth)), y:0)
        life.anchorPoint = CGPoint(x: 0, y: 0)
        
        // add the cat to the scene
        addChild(life)
        
        // add the cat to the cats array
        self.remainingLifeNode.append(life)
        print("Life Count = \(remainingLifeNode.count)")
    }
    
    // Generating UFO
    func makeUfo() {
        // lets add some cats
        let ufo = SKSpriteNode(imageNamed: "ufo")
        
        
        ufo.position = CGPoint(x:0, y:self.size.height + 100)
        ufo.anchorPoint = CGPoint(x: 0, y: 0)
        
        // add the cat to the scene
        addChild(ufo)
        //---------------------------
        //CREATING PHYSICS AND MASKS
        //---------------------------
        ufo.physicsBody = SKPhysicsBody(
            rectangleOf: CGSize(width: ufo.size.width, height: ufo.size.height))
        ufo.name = "ufo"
        ufo.physicsBody?.affectedByGravity = false
        ufo.physicsBody?.affectedByGravity = false
        ufo.physicsBody?.allowsRotation = false
        ufo.physicsBody?.isDynamic = false
        ufo.physicsBody?.categoryBitMask = 2
        ufo.physicsBody?.collisionBitMask = 1
        ufo.physicsBody?.contactTestBitMask = 1
        
        //---------------------------
        //END CREATING PHYSICS AND MASKS
        //---------------------------
        // add the cat to the cats array
        self.ufos.append(ufo)
    }
    
    // Generting AirCraft
    func makeAirCraft() {
        // lets add some cats
        let airCraft = SKSpriteNode(imageNamed: "aircraft")
        
        airCraft.position = CGPoint(x:self.size.width, y:self.size.height + 100)
        airCraft.anchorPoint = CGPoint(x: 0, y: 0)
        
        // add the cat to the scene
        addChild(airCraft)
        //---------------------------
        //CREATING PHYSICS AND MASKS
        //---------------------------
        airCraft.physicsBody = SKPhysicsBody(
            rectangleOf: CGSize(width: airCraft.size.width, height: airCraft.size.height))
        airCraft.name = "aircraft"
        airCraft.physicsBody?.affectedByGravity = false
        airCraft.physicsBody?.affectedByGravity = false
        airCraft.physicsBody?.allowsRotation = false
        airCraft.physicsBody?.isDynamic = false
        airCraft.physicsBody?.categoryBitMask = 2
        airCraft.physicsBody?.collisionBitMask = 1
        airCraft.physicsBody?.contactTestBitMask = 1
        
        //---------------------------
        //END CREATING PHYSICS AND MASKS
        //---------------------------
        
        // add the cat to the cats array
        self.aircrafts.append(airCraft)
    }
    
    // Generting Shuttles
    func makeShuttle() {
        // lets add some cats
        let shuttle = SKSpriteNode(imageNamed: "shuttle")
        
        shuttle.position = CGPoint(x:(self.size.width / 2), y:self.size.height + 100)
        shuttle.anchorPoint = CGPoint(x: 0, y: 0)
        // add the cat to the scene
        addChild(shuttle)
        shuttle.physicsBody = SKPhysicsBody(
            rectangleOf: CGSize(width: shuttle.size.width, height: shuttle.size.height))
        shuttle.name = "shuttle"
        shuttle.physicsBody?.affectedByGravity = false
        shuttle.physicsBody?.affectedByGravity = false
        shuttle.physicsBody?.allowsRotation = false
        shuttle.physicsBody?.isDynamic = false
        shuttle.physicsBody?.categoryBitMask = 2
        shuttle.physicsBody?.collisionBitMask = 1
        shuttle.physicsBody?.contactTestBitMask = 1
        
        // add the cat to the cats array
        self.shuttles.append(shuttle)
    }
    
    //creating long background
    func createBackground(){
        //setting images vertically at the end of one image, just to create one long image
        
        backgroundColor = SKColor.white
        background.anchorPoint = CGPoint(x: 0, y: 0)
        background.size = CGSize(width: self.size.width, height: self.size.height)
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = -1
        addChild(background)
        
        background2.size = CGSize(width: self.size.width, height: self.size.height)
        background2.anchorPoint = CGPoint(x: 0, y: 0)
        background2.position = CGPoint(x: 0, y: (background2.size.height - 1))
        background2.zPosition = -1
        addChild(background2)
    }
    
    // to give parallax effect
    func moveBackground(){
        
        // speed of image movement is 20
        background.position = CGPoint(x: 0, y: background.position.y - 20)
        background2.position = CGPoint(x: 0, y: background2.position.y - 20)
        
        // resetting background 1 position to top
        if(background.position.y < -(background.size.height)){
            background.position = CGPoint(x: 0, y: background2.position.y + background2.size.height)
        }
        
        // resetting background 2 position to top
        if(background2.position.y < -(background2.size.height)){
            background2.position = CGPoint(x: background2.position.x, y: background.position.y + background.size.height)
        }
    }
    
    @objc func updateTime() {
        
        if(timeLeft >= 0){
            let minutes = (timeLeft / 60)
            let seconds = (timeLeft % 60)
            if(seconds <= 9){
                timeLabel.text = "Time Left: " + String(minutes) + ":0" + String(seconds)
            } else {
                timeLabel.text = "Time Left: " + String(minutes) + ":" + String(seconds)
            }
            timeLeft -= 1
        }
        
        if(timeLeft <= -1) {
            timer.invalidate()
        }
        
    }
    
    var timer = Timer()
    override func didMove(to view: SKView) {
         self.physicsWorld.contactDelegate = self
        self.createBackground()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(GameScene.updateTime), userInfo: nil, repeats: true)
        // Create player
        self.player.position = CGPoint(x: 0, y: 100)
        self.player.anchorPoint = CGPoint(x: 0, y: 0)
        player.name = "jet"
        
        addChild(self.player)
        
        self.player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: player.size.width
            , height: player.size.height))
        self.player.physicsBody?.affectedByGravity = false
        self.player.physicsBody?.allowsRotation = false
        self.player.physicsBody?.isDynamic = false
        self.player.physicsBody?.categoryBitMask = 4
        self.player.physicsBody?.collisionBitMask = 8
        self.player.physicsBody?.contactTestBitMask = 8
        
        
        // drawing UFO
        for _ in 0...3 {
            makeUfo()
        }
        
        // drawing AirCraft
        for _ in 0...5 {
            makeAirCraft()
        }
        
        // draw shuttle
        for _ in 0...9 {
            makeShuttle()
        }
    
        //time bomb
        timeBomb = SKSpriteNode(imageNamed: "bomb")
        timeBomb?.position.x = 0
        timeBomb?.position.y = 0
        timeBomb?.anchorPoint = CGPoint(x: 0, y: 0)
        addChild(timeBomb!)
        
        
        // Label for score
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.fontSize = 50
        scoreLabel.fontColor = UIColor.yellow
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.verticalAlignmentMode = .top
        scoreLabel.position = CGPoint(x: 0, y: self.size.height)
        addChild(scoreLabel)
        
        // Label for time
        timeLabel = SKLabelNode(fontNamed: "Chalkduster")
        timeLabel.fontSize = 50
        timeLabel.fontColor = UIColor.yellow
        timeLabel.text = "Time Left: 2:00"
        timeLabel.horizontalAlignmentMode = .right
        timeLabel.verticalAlignmentMode = .top
        timeLabel.position = CGPoint(x: self.size.width, y: self.size.height)
        addChild(timeLabel)
        
        // add life to screen
        for i in 0...remainingLife - 1 {
                makeremainingLife(imgWidth: CGFloat(i+1))
        }
    }
    
    // variable to keep track of how much time has passed
    var timeOfLastUpdate:TimeInterval?
    // variable to keep track of how many ufo are there on screen
    var trackUfoCount = 0
    // variable to keep the x position of the last ufo
    var ufoInitialPosition:CGFloat = 225
    // variable to keep track of how many aircraft are there on screen
    var trackAirCraftCount = 0
    // variable to keep the x position of the last aircraft
    var airCraftInitialPosition:CGFloat = 175
    // variable to keep track of how many shuttle are there on screen
    var trackShuttleCount = 0
    // variable to keep the x position of the last shuttle
    var shuttleInitialPosition:CGFloat = 65
    
    
    // Grid Animation for UFO
    func makeUfoAppear() {
        
        // Action Sequencing
        let m1 = SKAction.move(to: CGPoint(x: self.size.width/2, y: self.size.height / 2), duration: 2)
        let m2 = SKAction.move(to: CGPoint(x: ufoInitialPosition, y: self.size.height * 0.9), duration: 2)
        let sequence:SKAction = SKAction.sequence([m1, m2])
        
        // running animation for each ufo individually
        if (trackUfoCount <= 3){
            ufos[trackUfoCount].run(sequence)
            trackUfoCount += 1
            // getting initial position of ufo, for setting each ufo exactly beside the previous ufo on grid
            ufoInitialPosition = ufoInitialPosition + ufos[trackUfoCount-1].size.width
        }
        
        
    }
    
    // Grid Animation for Air Craft
    func makeAirCraftAppear() {
        
        // Action Sequencing
        let m1 = SKAction.move(to: CGPoint(x: self.size.width/2, y: self.size.height / 2), duration: 2)
        let m2 = SKAction.move(to: CGPoint(x: airCraftInitialPosition, y: self.size.height * 0.8), duration: 2)
        let sequence:SKAction = SKAction.sequence([m1, m2])
        
        // running animation for each Air Craft individually
        if (trackAirCraftCount <= 5){
            aircrafts[trackAirCraftCount].run(sequence)
            trackAirCraftCount += 1
        }
        
        // getting initial position of aircraft, for setting each aircraft exactly beside the previous aircraft on grid
        airCraftInitialPosition = airCraftInitialPosition + aircrafts[trackAirCraftCount-1].size.width
    }
    
    // Grid Animation for Shuttle
    func makeShuttleAppear() {
        
        // Action Sequencing
        let m1 = SKAction.move(to: CGPoint(x: self.size.width/2, y: self.size.height / 2), duration: 2)
        let m2 = SKAction.move(to: CGPoint(x: shuttleInitialPosition, y: self.size.height * 0.7), duration: 2)
        let sequence:SKAction = SKAction.sequence([m1, m2])
        
        // running animation for each shuttle individually
        if (trackShuttleCount <= 9){
            shuttles[trackShuttleCount].run(sequence)
            trackShuttleCount += 1
        }
        
        // getting initial position of shuttle, for setting each shuttle exactly beside the previous shuttle on grid
        shuttleInitialPosition = shuttleInitialPosition + shuttles[trackShuttleCount-1].size.width
    }
    
    
    // -------------------
    // Player Movement Starts
    // -------------------
    var isMovingRight = true
    func makePlayerMove() {
        if(isMovingRight == true){
            self.player.position.x += 20
        } else if(isMovingRight == false){
            self.player.position.x -= 20
        }
        
        if(self.player.position.x >= (self.size.width - self.player.size.width)){
            isMovingRight = false
        } else if(self.player.position.x <= 0) {
            isMovingRight = true
        }
    }
    // -------------------
    // Player Movement Ends
    // -------------------
    
    
    // -------------------
    // Ufo Movement Starts
    // -------------------
    var isUfoMovingRight = true
    func makeUfoMove() {
        
        for i in 0...(ufos.count - 1) {
        if(isUfoMovingRight == true){
            self.ufos[i].position.x += 10
        } else if(isUfoMovingRight == false){
            self.ufos[i].position.x -= 10
        }
        }
        
        // rebouncing of ufo from left to right on basis of first and last ufo in the array list
        if((ufos.last?.position.x)! >= (self.size.width - (self.ufos.first?.size.width)!)){
            isUfoMovingRight = false
        } else if((ufos.first?.position.x)! <= 0) {
            isUfoMovingRight = true
        }
    }
    // -------------------
    // Ufo Movement Ends
    // -------------------
    
    // -------------------
    // AirCraft Movement Starts
    // -------------------
    var isAirCraftMovingRight = false
    func makeAirCraftMove() {
        for i in 0...(aircrafts.count - 1) {
            if(isAirCraftMovingRight == true){
                self.aircrafts[i].position.x += 10
            } else if(isAirCraftMovingRight == false){
                self.aircrafts[i].position.x -= 10
            }
        }
        
        // rebouncing of aircraft from left to right on basis of first and last aircraft in the array list
        if((aircrafts.last?.position.x)! >= (self.size.width - (self.aircrafts.first?.size.width)!)){
            isAirCraftMovingRight = false
        } else if((aircrafts.first?.position.x)! <= 0) {
            isAirCraftMovingRight = true
        }
    }
    // -------------------
    // AirCraft Movement Ends
    // -------------------
    
    // -------------------
    // Shuttle Movement Starts
    // -------------------
    var isShuttleMovingRight = true
    func makeShuttleMove() {
        for i in 0...(shuttles.count - 1) {
            if(isShuttleMovingRight == true){
                self.shuttles[i].position.x += 10
            } else if(isShuttleMovingRight == false){
                self.shuttles[i].position.x -= 10
            }
        }
        
        // rebouncing of shuttle from left to right on basis of first and last shuttl in the array list
        if((shuttles.last?.position.x)! >= (self.size.width - (self.shuttles.first?.size.width)!)){
            isShuttleMovingRight = false
        } else if((shuttles.first?.position.x)! <= 0) {
            isShuttleMovingRight = true
        }
    }
    // -------------------
    // Shuttle Movement Ends
    // -------------------
    
    // -------------------
    // Player Bullet Starts
    // -------------------
    var bullets:[SKSpriteNode] = []
    func makeBullet(xPosition:CGFloat, yPosition:CGFloat) {
        // lets add some cats
        let bullet = SKSpriteNode(imageNamed: "bullet")
        
        bullet.position = CGPoint(x:xPosition, y:yPosition)
        bullet.zPosition = 100
        
        // add the cat to the scene
        addChild(bullet)
        bullet.name = "bullet"
        bullet.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: bullet.size.width,height: bullet.size.height))
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.allowsRotation = false
        bullet.physicsBody?.categoryBitMask = 1
        bullet.physicsBody?.collisionBitMask = 2
        bullet.physicsBody?.contactTestBitMask = 2
        // add the cat to the cats array
        self.bullets.append(bullet)
    }
    
    // moving all bullets in the array by 30
    func moveBullet() {
        if(bullets.count != 0){
        for i in 0...(bullets.count - 1) {
            self.bullets[i].position.y = self.bullets[i].position.y + 30
            //remove bullet from scene
            if(bullets[i].position.y > self.size.height)
            {
                bullets[i].removeFromParent()
            }
        }
        }
    }
    // -------------------
    // Player Bullet Ends
    // -------------------
    
    // -------------------
    // AirCraft Bullet Starts
    // -------------------
    var airCraftbullets:[SKSpriteNode] = []
    func makeAirCraftBullet() {
        // randomly generate where the chopstick
        let randomAirBullet = Int.random(in: 0...(aircrafts.count - 1))
        
        // lets add some bullets
        let airBullet = SKSpriteNode(imageNamed: "fireball")
        
        airBullet.position = CGPoint(x:(aircrafts[randomAirBullet].position.x + (aircrafts[randomAirBullet].size.width / 2)), y:aircrafts[randomAirBullet].position.y)
        
        // add the bullets to the scene
        addChild(airBullet)
        //---------------------------
        //CREATING PHYSICS AND MASKS
        //---------------------------
        airBullet.physicsBody = SKPhysicsBody(
            rectangleOf: CGSize(width: airBullet.size.width, height: airBullet.size.height))
        airBullet.name = "airbullet"
        airBullet.physicsBody?.affectedByGravity = false
       // airBullet.physicsBody?.allowsRotation = false
        //airBullet.physicsBody?.isDynamic = false
       airBullet.physicsBody?.categoryBitMask = 8
//        airBullet.physicsBody?.collisionBitMask = 4
//        airBullet.physicsBody?.contactTestBitMask = 4
        
        //---------------------------
        //END CREATING PHYSICS AND MASKS
        //---------------------------
        // add the cat to the cats array
        self.airCraftbullets.append(airBullet)
    }
    
    // moving aircraft bullet by 20
    func moveAirCraftBullet() {
        if(airCraftbullets.count != 0){
            for i in 0...(airCraftbullets.count - 1) {
                self.airCraftbullets[i].position.y = self.airCraftbullets[i].position.y - 20
            }
        }
    }
    // -------------------
    // AirCraft Bullet Ends
    // -------------------
    
    
    // -------------------
    // Making UFO move towards the player
    // -------------------
    var xd:CGFloat = 0
    var yd:CGFloat = 0
    var UFOremoveCount = 0
    var pastTime:TimeInterval?
    func enemyTowardsPlayer(time:TimeInterval){
        
        if (pastTime == nil) {
            pastTime = time
        }
       
        let timePassed = (time - pastTime!)
        if (timePassed >= 10 && ufos.count > 1) {
       
         let randomUFOMove = Int.random(in: 0...(ufos.count - 1))
            moveUFO = ufos[randomUFOMove]
            UFODown = 0
            ufos.remove(at: randomUFOMove)
            pastTime = time
           
          
        }
        if(moveUFO != nil){
            let a = player.position.x - moveUFO.position.x
            // (y2-y1)
            let b = player.position.y - moveUFO.position.y
            // d
            let d = sqrt( (a*a) + (b*b))
            
            self.xd = a/d
            self.yd = b/d
        moveUFO.position.x = moveUFO.position.x + self.xd * 10
            moveUFO.position.y = moveUFO.position.y + (self.yd - 1.5) * 6}
        
    }
    
    //MOVING PLAYER ON TAP
    func movePlayerOnTap(speed:CGFloat,mousePos:CGPoint)
    {
      //  self.player.position.x += speed
        
        let a =  mousePos.x - player.position.x
        // (y2-y1)
        let b = mousePos.y - player.position.y
        // d
        let d = sqrt( (a*a) + (b*b))
        
        self.xd = a/d
        self.yd = b/d
        player.position.x = player.position.x + self.xd * speed
        player.position.x = (player.position.x + self.yd * speed)
//        if(self.player.position.x >= (self.size.width - self.player.size.width)){
//            PLspeed = 0
//        } else if(self.player.position.x <= 0) {
//            PLspeed = 0
//        }
    }
    func didBegin(_ contact: SKPhysicsContact) {
        let objectA = contact.bodyA.node!
        let objectB = contact.bodyB.node!
        // COLLISION WITH UFO
        if (objectA.name == "bullet" && objectB.name == "ufo") {
           // print("GAME OVER!")
            objectB.removeFromParent()
            objectA.removeFromParent()
            UFOCount += 1
        }
        else if (objectA.name == "ufo" && objectB.name == "bullet") {
            //print("GAME OVER!")
           
           objectA.removeFromParent()
            objectB.removeFromParent()
            UFOCount += 1
        }
        // COLLISION WITH AIRCRAFT
         if (objectA.name == "bullet" && objectB.name == "aircraft") {
           // print("GAME OVER!")
            objectB.removeFromParent()
            objectA.removeFromParent()
            AIRCRAFTCount += 1
        }
        else if (objectA.name == "aircraft" && objectB.name == "bullet") {
           // print("GAME OVER!")
            objectA.removeFromParent()
            objectB.removeFromParent()
            AIRCRAFTCount += 1
        }
        
            // COLLISION WITH SHUTTLE
         if (objectA.name == "bullet" && objectB.name == "shuttle") {
           // print("GAME OVER!")
            objectB.removeFromParent()
            objectA.removeFromParent()
        }
        else if (objectA.name == "shuttle" && objectB.name == "bullet") {
           // print("GAME OVER!")
            objectA.removeFromParent()
            objectB.removeFromParent()
        }
        // ENEMY BULLET WITH PLAYER
         if (objectA.name == "airbullet" && objectB.name == "jet") {
            print("PLAYER DIE")
            objectB.removeFromParent()
           objectA.removeFromParent()
            decreaseLivescount = true
            decreasePlayerLifeCount(live: decreaseLivescount)
            //decrease player life
        }
        else if (objectA.name == "jet" && objectB.name == "airbullet") {
            print("PLAYER DIE")
          objectA.removeFromParent()
          objectB.removeFromParent()
            decreaseLivescount = true
            decreasePlayerLifeCount(live: decreaseLivescount)
        }
        
        
//        else if (objectA.name == "cat" && objectB.name == "bed") {
//            print("YOU WIN")
//            // stop moving the cat when game wins
//            objectA.physicsBody?.isDynamic = false
//        }
//        else if (objectA.name == "bed" && objectB.name == "cat") {
//            print("YOU WIN")
//            // stop moving the cat when game wins
//            objectB.physicsBody?.isDynamic = false;
//        }

        // GAME WIN RULES

    }
    
    //FUNCTION TO REMOVE THE PLAYER FROM SCENE AND DECREASE THE LIVES
    func decreasePlayerLifeCount(live:Bool){
        if(decreaseLivescount == true ){
            //removing from scene
            remainingLifeNode.last?.removeFromParent()
            
            //removing from array
            self.remainingLifeNode.remove(at: self.remainingLifeNode.count - 1)
            print(" show \(self.remainingLifeNode.count)")
            print(" flag before \(decreaseLivescount) ")
            player.position = CGPoint(x: 400, y: 100)
            addChild(self.player)
            //RESTARTING THE SCENE IF PLAYER LIVES ARE OVER
            if(remainingLifeNode.count == 0)
            {
                let newScene = GameScene(size: self.size)
                newScene.scaleMode = self.scaleMode
                let animation = SKTransition.fade(withDuration: 1.0)
                self.view?.presentScene(newScene, transition: animation)
            }
            decreaseLivescount = false;
            print(" flag after \(decreaseLivescount) ")
        }
    }
    
    
    
    // Variables to set grids and firing aricraft bullet at random time
    var isGridSet = false
    var isGridSetTimer:TimeInterval?
    var bulletTime:TimeInterval?
    var playerBulletTime:TimeInterval?
    var ufoCollideTime:TimeInterval?
    
    // ---------------------
    // UPDATE FUNCTION
    //--------------------
    
    override func update(_ currentTime: TimeInterval) {
        
        //CHECKING GAME WIN CONDITION
        print("UFO's LEft: \(UFOCount)")
        
        if (ufoCollideTime == nil) {
            ufoCollideTime = currentTime
        }
        // Called before each frame is rendered
        self.moveBackground()
        
        // call player move
        //self.makePlayerMove()
        
        if (timeOfLastUpdate == nil) {
            timeOfLastUpdate = currentTime
        }
        // print a message every 3 seconds
        let timePassed = (currentTime - timeOfLastUpdate!)
        
        if (timePassed >= 2) {
            timeOfLastUpdate = currentTime
            // Make Ufo Appear on screen
            makeUfoAppear()
            // Make airCraft Appear on screen
            makeAirCraftAppear()
            // Make Shuttle Appear on screen
           // makeShuttleAppear()
            
           
        }
        
        // gird setting flag
        if(trackUfoCount == 4 && trackAirCraftCount == 6 /* && trackShuttleCount == 10*/){
            if (isGridSetTimer == nil) {
                isGridSetTimer = currentTime
            }
            let gridTimePassed = (currentTime - isGridSetTimer!)
            if(gridTimePassed >= 5) {
                isGridSet = true
                isGridSetTimer = currentTime
            }
        }
        
        // calling functions to make enemies start moving
        if(isGridSet == true){
            makeUfoMove()
            makeAirCraftMove()
            //makeShuttleMove()
            moveBullet()
            moveAirCraftBullet()
            
            //calling the enemy move functon
            enemyTowardsPlayer(time: currentTime)
            
        }
        
        //PLAYER AUTOMATIC BULLET
        if (playerBulletTime == nil) {
            playerBulletTime = currentTime
        }
        let PLbulletTimePassed = (currentTime - playerBulletTime!)
        if(PLbulletTimePassed >= 2 && isGridSet == true) {
            
            //AUTOMATIC BULLETS
            let playerX = self.player.position.x + (self.player.size.width / 2)
            let playerY = self.player.position.y + (self.player.size.height / 2)
            //making bullets only if player lives are left
            if(remainingLifeNode.count != 0){
                makeBullet(xPosition: playerX, yPosition: playerY)
                
            }
            playerBulletTime = currentTime
        }
         //END PLAYER AUTOMATIC BULLET ------------------
        
        if (bulletTime == nil) {
            bulletTime = currentTime
        }
        
        let bulletTimePassed = (currentTime - bulletTime!)
        if(bulletTimePassed >= 5 && isGridSet == true) {
            makeAirCraftBullet()
            
            bulletTime = currentTime
        }
        
        //PLAYER MOVEMENT
        if(mousePosition != nil){
        movePlayerOnTap(speed: PLspeed,mousePos: mousePosition!)
        }
        //Detecting intersection with ufo
        if(moveUFO != nil){
            
            // print a message every 3 seconds
            let collidehapped = (currentTime - ufoCollideTime!)
            
            
        
        if (self.player.intersects(moveUFO) == true || moveUFO.position.y < 100) {
            // ufo die
            if (collidehapped >= 4) {
            moveUFO.removeFromParent()
            
            //player die
            player.removeFromParent()
            //live decrease
            //UFOCount += 1
              decreaseLivescount = true
             ufoCollideTime = currentTime
        }
            }
    
        }
        
        //taking count because it collides too many times
        decreasePlayerLifeCount(live:decreaseLivescount)
        
        
    }
    
  
    var mousePosition:CGPoint?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        mousePosition = touches.first?.location(in: self)
        
        PLspeed = 20
    }
    
    
}
