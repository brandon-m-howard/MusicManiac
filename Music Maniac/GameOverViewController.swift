//
//  GameOverViewController.swift
//  Music Maniac
//
//  Created by Brandon Howard on 5/2/16.
//  Copyright © 2016 Ticklin' The Ivories. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {

	var levelPrefix = ""
	let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()

	@IBOutlet weak var scoreLabel: UILabel!
	var score = 0

	override func viewWillAppear(animated: Bool) {

		let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(GameOverViewController.handleMenuPress))
		tapRecognizer.allowedPressTypes = [UIPressType.Menu.rawValue]
		view.addGestureRecognizer(tapRecognizer)

		let highScore = userDefaults.integerForKey("score" + levelPrefix)

		if highScore >= score || score == 0 {
			scoreLabel.text = "Score:  \(score)"
		} else {
			scoreLabel.text = "High Score! Score: \(score)"
			userDefaults.setObject(score, forKey: "score" + levelPrefix)
			userDefaults.synchronize()
		}
	}

	func handleMenuPress() {

	}

}
