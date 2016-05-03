//
//  GameViewController.swift
//  Music Maniac
//
//  Created by Brandon Howard on 4/24/16.
//  Copyright (c) 2016 Ticklin' The Ivories. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

	var score = 0
	var scene: GameScene!
	var levelPrefix = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        scene = GameScene(fileNamed: "GameScene")
		let skView = self.view as! SKView
		skView.ignoresSiblingOrder = true
		skView.showsPhysics = false
		scene.scaleMode = .AspectFill
		skView.presentScene(scene)
		scene.levelPrefix = self.levelPrefix
		scene.controller = self
    }

	@IBAction func unwindToGame(segue: UIStoryboardSegue) {
		scene.setupGame()
	}

	func toGameOver() {
		self.performSegueWithIdentifier("ToGameOver", sender: self)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "ToGameOver" {
			let dst = segue.destinationViewController as! GameOverViewController
			dst.score = self.score
			dst.levelPrefix = self.levelPrefix
		}
	}
}
