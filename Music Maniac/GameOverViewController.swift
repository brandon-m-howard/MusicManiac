//
//  GameOverViewController.swift
//  Music Maniac
//
//  Created by Brandon Howard on 5/2/16.
//  Copyright © 2016 Ticklin' The Ivories. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {

	@IBOutlet weak var scoreLabel: UILabel!
	var score = 0

	override func viewWillAppear(animated: Bool) {
		scoreLabel.text = "Score:  \(score)"
	}

}
