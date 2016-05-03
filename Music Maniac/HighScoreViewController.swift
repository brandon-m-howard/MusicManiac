//
//  HighScoreViewController.swift
//  Music Maniac
//
//  Created by Brandon Howard on 4/24/16.
//  Copyright © 2016 Ticklin' The Ivories. All rights reserved.
//

import UIKit

class HighScoreViewController: UIViewController {

	let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()

	@IBOutlet weak var easyLabel: UILabel!
	@IBOutlet weak var normalLabel: UILabel!

	override func viewWillAppear(animated: Bool) {
		let easyScore = userDefaults.integerForKey("score 2")
		let normalScore = userDefaults.integerForKey("score")
		easyLabel.text = "Easy: \(easyScore)"
		normalLabel.text = "Normal: \(normalScore)"
	}

}