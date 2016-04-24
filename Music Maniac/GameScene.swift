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
	var health = 3

	override func didMoveToView(view: SKView) {
		bluetooth = BluetoothManager()
		bluetooth.setup()
		bluetooth.delegate = self

		addGravityToView()
		addBackground()
		addGround()
		addHealth()
		addAlpacaToView()
	}

	func addGravityToView() {
		self.physicsWorld.gravity = CGVectorMake(0.0, -2)
	}

	func addAlpacaToView() {
		alpaca = SKSpriteNode(imageNamed: "Alpaca")
		alpaca.xScale = 0.25
		alpaca.yScale = 0.25
		alpaca.anchorPoint = CGPointZero
		alpaca.position = CGPointMake(0, frame.height / 2.75)
		alpaca.physicsBody = SKPhysicsBody(circleOfRadius: alpaca.size.height / 2.75)
		alpaca.physicsBody?.dynamic = true
		self.addChild(alpaca)
	}

	func addBackground() {

	}

	func addGround() {

	}

	func addHealth() {

	}

	func jump() {
		alpaca.physicsBody!.velocity = CGVectorMake(0, 0)
		alpaca.physicsBody!.applyImpulse(CGVectorMake(0, 280))
	}

	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

		for touch in touches {
			jump()
		}

	}

	override func update(currentTime: CFTimeInterval) {
		print(currentTime)
	}

	
	func playSound(sound: String) {
		let soundAction = SKAction.playSoundFileNamed(sound, waitForCompletion: false)
		self.runAction(soundAction)
	}

	func keyWasPressed(key: String) {
		playSound(key)
		print(key)
	}
}