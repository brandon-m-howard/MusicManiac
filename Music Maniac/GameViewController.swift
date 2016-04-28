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

    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene(fileNamed: "GameScene") {
            let skView = self.view as! SKView
            skView.ignoresSiblingOrder = true
			skView.showsPhysics = true
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
			scene.controller = self
        }
    }

	func toGameOver() {
		self.performSegueWithIdentifier("ToGameOver", sender: self)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
