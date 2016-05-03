//
//  LevelSelectViewController.swift
//  Music Maniac
//
//  Created by Brandon Howard on 5/3/16.
//  Copyright © 2016 Ticklin' The Ivories. All rights reserved.
//

import UIKit

class LevelSelectViewController: UIViewController {

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "Easy" {
			let dst = segue.destinationViewController as! GameViewController
			dst.levelPrefix = " 2"
		}
	}

}
