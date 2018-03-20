//
//  PlayViewController.swift
//  nusic
//
//  Created by SyotaTsuda on 2018/03/21.
//  Copyright © 2018年 Syota Tsuda. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = UIColor.white
		
		let label = UILabel()
		label.text = "Play"
		label.font = UIFont.boldSystemFont(ofSize: 30)
		label.sizeToFit()
		label.center = self.view.center
		self.view.addSubview(label)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
}
