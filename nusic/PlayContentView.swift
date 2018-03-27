//
//  PlayContentView.swift
//  nusic
//
//  Created by SyotaTsuda on 2018/03/26.
//  Copyright © 2018年 Syota Tsuda. All rights reserved.
//

import UIKit

class PlayContentView: UIView {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		loadNib()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		loadNib()
	}
	
	private func loadNib() {
		let viewPlay = UINib(nibName: "PlayContentView", bundle: Bundle(for: PlayContentView.self)).instantiate(withOwner: self, options: nil)[0] as! UIView
		viewPlay.frame = self.bounds
		addSubview(viewPlay)
	}
	
	override func prepareForInterfaceBuilder() {
		loadNib()
	}

}
