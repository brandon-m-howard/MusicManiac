//
//  GameScene.swift
//  Music Maniac
//
//  Created by Brandon Howard on 4/24/16.
//  Copyright (c) 2016 Ticklin' The Ivories. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, BluetoothManagerDelegate, SKPhysicsContactDelegate {

	var gameIsActive = true
	var canPlayKey = true
	var bluetooth: BluetoothManager!
	var alpaca: SKSpriteNode!
	var ground = [SKSpriteNode]()
	var hearts = [SKSpriteNode]()
	var scoreLabel: SKLabelNode!
	var note: SKSpriteNode!
	var noteString: String!
	var soundActions = [SKAction]()
	let GROUND_BLOCKS = 20
	let MAX_HEALTH = 3
	var health = 0
	var score = 0
	let noteCategory: UInt32 = 0x1 << 0
	let alpacaCategory: UInt32 = 0x1 << 1
	let groundCategory: UInt32 = 0x1 << 2
	var controller: GameViewController!
	var healthRegeneration = 0
	let nHealthRegeneration = 3
	var levelPrefix = ""
	var timeBetweenNotes = 8.0
	var buzzer: SKAction!
	var explosion: SKAction!
	var explosionEmitterNode: SKEmitterNode!

	override func didMoveToView(view: SKView) {
		setupGame()
		bluetooth = BluetoothManager()
		bluetooth.setup()
		bluetooth.delegate = self
	}

	func setupGame() {
		self.physicsWorld.contactDelegate = self // For collision detection
		score = 0
		health = 0
		setupAudio()
		addGravityToView()
		addBackground()
		addGround()
		addHealth()
		addAlpacaToView()
		addScore()
		setupNoteAction()
	}

	func setupAudio() {

		let backgroundMusic = SKAudioNode(fileNamed: "ChariotsOfFire")
		backgroundMusic.autoplayLooped = true
		self.addChild(backgroundMusic)

		buzzer = SKAction.playSoundFileNamed("Buzzer", waitForCompletion: false)
		explosion = SKAction.playSoundFileNamed("explosion", waitForCompletion: false)

		let c0 = SKAction.playSoundFileNamed("C0", waitForCompletion: false)
		soundActions.append(c0)
		let d = SKAction.playSoundFileNamed("D", waitForCompletion: false)
		soundActions.append(d)
		let e = SKAction.playSoundFileNamed("E", waitForCompletion: false)
		soundActions.append(e)
		let f = SKAction.playSoundFileNamed("F", waitForCompletion: false)
		soundActions.append(f)
		let g = SKAction.playSoundFileNamed("G", waitForCompletion: false)
		soundActions.append(g)
		let a = SKAction.playSoundFileNamed("A", waitForCompletion: false)
		soundActions.append(a)
		let b = SKAction.playSoundFileNamed("B", waitForCompletion: false)
		soundActions.append(b)
		let c1 = SKAction.playSoundFileNamed("C1", waitForCompletion: false)
		soundActions.append(c1)
	}

	func setupNoteAction() {
		let waitAction = SKAction.waitForDuration(timeBetweenNotes)
		let noteAction = SKAction.runBlock({ self.addNote(); self.canPlayKey = true })
		let sequenceAction = SKAction.sequence([noteAction, waitAction])
		let repeatAction = SKAction.repeatActionForever(sequenceAction)
		self.runAction(repeatAction)
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
		self.physicsWorld.gravity = CGVectorMake(0.0, -1)
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
		alpaca.physicsBody?.friction = 1.0
		alpaca.physicsBody?.usesPreciseCollisionDetection = true
		alpaca.physicsBody?.contactTestBitMask = noteCategory
		alpaca.physicsBody?.categoryBitMask = alpacaCategory
		self.addChild(alpaca)
	}

	func addBackground() {
		let background = SKSpriteNode(imageNamed: "sky")
		background.position = CGPoint(x: 0, y: 0)
		background.anchorPoint = CGPoint(x: 0, y: 0)
		background.size.width = self.frame.size.width
		background.size.height = self.frame.size.height
		background.zPosition = -2
		self.addChild(background)
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
		for iHealth in 0..<MAX_HEALTH {
			let heart = SKSpriteNode(imageNamed: "heart")
			hearts.append(heart)
			heart.xScale = 0.25
			heart.yScale = 0.25
			heart.position = CGPointMake(self.frame.width - CGFloat(iHealth+1)*heart.size.width - CGFloat(iHealth)*10, self.frame.height - heart.size.height*3)
			heart.zPosition = 0
			self.addChild(heart)
		}
	}

	@IBAction func unwindToGameScreen(segue: UIStoryboardSegue) {
		setupGame()
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

	func addNote() {
		let noteString = randomNoteString()
		let note = SKSpriteNode(imageNamed: noteString + levelPrefix)
		note.xScale = 0.25
		note.yScale = 0.25
		note.position = CGPointMake(self.frame.width + note.size.width, 290)
		note.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: note.size.width, height: note.size.height))
		note.physicsBody?.dynamic = true
		note.physicsBody?.allowsRotation = false
		note.zPosition = 1
		note.physicsBody?.friction = 1.0
		note.physicsBody?.usesPreciseCollisionDetection = true
		note.physicsBody?.categoryBitMask = noteCategory
		note.physicsBody?.collisionBitMask = alpacaCategory
		note.physicsBody?.contactTestBitMask = alpacaCategory
		let moveAction = SKAction.moveToX(-note.size.width, duration: 10)
		let deleteAction = SKAction.removeFromParent()
		let sequenceAction = SKAction.sequence([moveAction, deleteAction])
		note.runAction(sequenceAction)
		self.addChild(note)
	}

	func jump() {
		alpaca.physicsBody!.velocity = CGVectorMake(0, 0)
		alpaca.physicsBody!.applyImpulse(CGVectorMake(0, 550))
	}

	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//		jump()
	}

	func destroyNote() {
		note.removeFromParent()
	}

	override func update(currentTime: CFTimeInterval) {
		if (health <= 0) {
			print("GAME OVER")
			gameIsActive = false
			self.removeAllActions()
			self.removeAllChildren()
			health = 3
			controller.score = self.score
			controller.toGameOver()
			controller = nil
		}
	}

	func incrementScore() {
		score += 1
		scoreLabel.text = "Score:  \(score)"
		incrementHealth()
	}

	func decrementHealth() {
		if health > 0 {
			health -= 1
			hearts[health].hidden = true
		}
	}

	func incrementHealth() {
		if health < MAX_HEALTH && healthRegeneration == nHealthRegeneration - 1 {
			health += 1
			hearts[health - 1].hidden = false
			healthRegeneration = 0
		}
		healthRegeneration = (healthRegeneration + 1) % nHealthRegeneration
	}

	
	func playSound(sound: String) {
		switch (sound) {
		case "C0":
			runAction(soundActions[0])
		case "D":
			runAction(soundActions[1])
		case "E":
			runAction(soundActions[2])
		case "F":
			runAction(soundActions[3])
		case "G":
			runAction(soundActions[4])
		case "A":
			runAction(soundActions[5])
		case "B":
			runAction(soundActions[6])
		case "C1":
			runAction(soundActions[7])
		default:
			runAction(soundActions[0])
		}
	}

	func didBeginContact(contact: SKPhysicsContact) {

		if (contact.bodyA.categoryBitMask == alpacaCategory) &&
			(contact.bodyB.categoryBitMask == noteCategory) {
			print("COLLISION")
			let card = contact.bodyB.node as! SKSpriteNode

			explosionEmitterNode = SKEmitterNode(fileNamed:"ExplosionEffect")
			explosionEmitterNode!.position = CGPointMake(card.position.x,card.position.y)
			explosionEmitterNode.particleColor = UIColor.orangeColor()

			addChild(explosionEmitterNode!)

			let fadeAction = SKAction.fadeOutWithDuration(1)
			let removeAction = SKAction.runBlock({ self.explosionEmitterNode.removeFromParent() })
			let sequenceAction = SKAction.sequence([fadeAction, removeAction])

			card.removeFromParent()
			runAction(explosion)
			explosionEmitterNode.runAction(sequenceAction)
			decrementHealth()
		}


	}

	func keyWasPressed(key: String) {
		if (gameIsActive) {
			if (key == noteString && canPlayKey) {
				canPlayKey = false
				jump()
				playSound(key)
				incrementScore()
				if timeBetweenNotes > 5 {
					timeBetweenNotes -= 0.1
				}
			} else if key == noteString && !canPlayKey {
				// nothing?
			} else {
				runAction(buzzer)
				decrementHealth()
			}
		}
	}
}