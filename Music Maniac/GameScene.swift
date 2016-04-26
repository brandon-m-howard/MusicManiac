//
//  GameScene.swift
//  Music Maniac
//
//  Created by Brandon Howard on 4/24/16.
//  Copyright (c) 2016 Ticklin' The Ivories. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, BluetoothManagerDelegate {

	var bluetooth: BluetoothManager!
	var alpaca: SKSpriteNode!
	var ground = [SKSpriteNode]()
	var scoreLabel: SKLabelNode!
	var note: SKSpriteNode!
	var noteString: String!
	let GROUND_BLOCKS = 20
	let MAX_HEALTH = 3
	var health = 0
	var score = 0

	override func didMoveToView(view: SKView) {
		bluetooth = BluetoothManager()
		bluetooth.setup()
		bluetooth.delegate = self

		addGravityToView()
		addBackground()
		addGround()
		addHealth()
		addAlpacaToView()
		addScore()
		addNote(randomNoteString())
	}

	func randomNoteString() -> String {
		let random = Int(arc4random_uniform(8))
		switch (random) {
		case 1:
			noteString = "C0"
			return "C0"
		case 2:
			noteString = "D"
			return "D"
		case 3:
			noteString = "E"
			return "E"
		case 4:
			noteString = "F"
			return "F"
		case 5:
			noteString = "G"
			return "G"
		case 6:
			noteString = "A"
			return "A"
		case 7:
			noteString = "B"
			return "B"
		case 8:
			noteString = "C1"
			return "C1"
		default:
			noteString = "C1"
			return "C1"
		}
	}

	func addGravityToView() {
		self.physicsWorld.gravity = CGVectorMake(0.0, -4.9)
	}

	func addAlpacaToView() {
		alpaca = SKSpriteNode(imageNamed: "Alpaca")
		alpaca.xScale = 0.25
		alpaca.yScale = 0.25
		alpaca.position = CGPointMake(200, frame.height / 2.75)
		alpaca.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: alpaca.size.width - 20, height: alpaca.size.height - 20))
		alpaca.physicsBody?.dynamic = true
		alpaca.physicsBody?.allowsRotation = false
		alpaca.zPosition = 1
		self.addChild(alpaca)
	}

	func addBackground() {
		var background = SKSpriteNode(imageNamed: "sky")
		background.position = CGPoint(x: 0, y: 0)
		background.anchorPoint = CGPoint(x: 0, y: 0)
		background.size.width = self.frame.size.width
		background.size.height = self.frame.size.height
		background.zPosition = -2
		self.addChild(background)

//		var cloud1 = SKSpriteNode(imageNamed: "cloud1")
//		cloud1.position = CGPointMake(200, frame.height / 2.75)
//		let move = SKAction.moveToX(-cloud1.size.width, duration: 10)
//		cloud1.zPosition = -1
//		cloud1.runAction(move)
//		self.addChild(cloud1)
	}

	func addGround() {
		for iBlock in 0..<GROUND_BLOCKS {
			let block = SKSpriteNode(imageNamed: "Ground")
			ground.append(block)
			block.xScale = 1.0
			block.yScale = 1.0
			block.position = CGPointMake(0 + CGFloat(iBlock)*block.size.width, 125)
			block.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: block.size.width, height: block.size.height))
			block.physicsBody?.dynamic = false
			block.zPosition = 0
			self.addChild(block)
		}
	}

	func addHealth() {
		health = MAX_HEALTH
	}

	func addScore() {
		scoreLabel = SKLabelNode(fontNamed: "Cassius Garrod")
		scoreLabel.fontSize = 40
		scoreLabel.text = "Score:  \(score)"
		scoreLabel.horizontalAlignmentMode = .Left
		scoreLabel.verticalAlignmentMode = .Top
		scoreLabel.position = CGPoint(x: 20, y: self.frame.height - 110)
		scoreLabel.zPosition = 0
		self.addChild(scoreLabel)
	}

	func jump() {
		alpaca.physicsBody!.velocity = CGVectorMake(0, 0)
		alpaca.physicsBody!.applyImpulse(CGVectorMake(0, 1000))
	}

	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

		for touch in touches {
			destroyNote()
			jump()
			addNote(randomNoteString())
		}

	}

	func destroyNote() {
		note.removeFromParent()
	}

	override func update(currentTime: CFTimeInterval) {
		incrementScore()
	}

	func incrementScore() {
		score += 1
		scoreLabel.text = "Score:  \(score)"
	}

	
	func playSound(sound: String) {
		let soundAction = SKAction.playSoundFileNamed(sound, waitForCompletion: false)
		self.runAction(soundAction)
	}

	func addNote(noteString: String) {
		note = SKSpriteNode(imageNamed: noteString)
		note.xScale = 0.25
		note.yScale = 0.25
		note.position = CGPointMake(500, 500)
		note.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: note.size.width, height: note.size.height))
		note.physicsBody?.dynamic = true
		note.physicsBody?.allowsRotation = false
		note.zPosition = 1
		self.addChild(note)
	}

	func keyWasPressed(key: String) {
		playSound(key)
		print(key)

		if (key == noteString) {
			jump()
		}
	}
}