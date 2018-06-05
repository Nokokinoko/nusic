//
//  Define.swift
//  nusic
//
//  Created by SyotaTsuda on 2018/03/31.
//  Copyright © 2018年 Syota Tsuda. All rights reserved.
//

import UIKit

struct Define {
	static let ColorBlack: UIColor = UIColor(red: 0.27, green: 0.27, blue: 0.32, alpha: 1.0) // #454552
	static let ColorGray: UIColor = UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1.0) // #EAEAEA
	static let ColorBlue: UIColor = UIColor(red: 0.31, green: 0.63, blue: 0.84, alpha: 1.0) // #4EA1D5
	static let ColorPink: UIColor = UIColor(red: 0.91, green: 0.35, blue: 0.44, alpha: 1.0) // #E85A70
	
	static let NameLocalizedString: String = "InfoPlist"
	
	static let KeyIsTimer: String = "IsTimer"
	static let KeySettingTimer: String = "SettingTimer"
	
	static let NoImage: UIImage = UIImage(named: "NoImage")!
	
	static let ImagePlay: UIImage = UIImage(named: "CtrlPlay")!
	static let ImagePause: UIImage = UIImage(named: "CtrlPause")!
	static let ImageNext: UIImage = UIImage(named: "CtrlNext")!
	static let ImagePrev: UIImage = UIImage(named: "CtrlPrev")!
	
	static let ImageShuffleOn: UIImage = UIImage(named: "CtrlShuffleOn")!
	static let ImageShuffleOff: UIImage = UIImage(named: "CtrlShuffleOff")!
	
	static let ImageRepeatOn: UIImage = UIImage(named: "CtrlRepeatOn")!
	static let ImageRepeatOne: UIImage = UIImage(named: "CtrlRepeatOne")!
	static let ImageRepeatOff: UIImage = UIImage(named: "CtrlRepeatOff")!
	
	static let ImageTimerOn: UIImage = UIImage(named: "CtrlTimerOn")!
	static let ImageTimerOff: UIImage = UIImage(named: "CtrlTimerOff")!
}
