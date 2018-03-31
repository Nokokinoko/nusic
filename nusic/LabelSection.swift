//
//  LabelSection.swift
//  nusic
//
//  Created by SyotaTsuda on 2018/04/01.
//  Copyright © 2018年 Syota Tsuda. All rights reserved.
//

import UIKit

class LabelSection: UILabel {
	
	private let _Padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	private func setup() {
		self.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
		self.textColor = Define.ColorLabel
		self.backgroundColor = Define.ColorBGSection
	}
	
	override func drawText(in rect: CGRect) {
		super.drawText(in: UIEdgeInsetsInsetRect(rect, _Padding))
	}
	
}
