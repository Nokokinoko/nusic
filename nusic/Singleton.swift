//
//  Singleton.swift
//  nusic
//
//  Created by SyotaTsuda on 2018/03/17.
//  Copyright © 2018年 Syota Tsuda. All rights reserved.
//

import Foundation

final class Singleton {
	
	private init() {}
	static let sharedInstance = Singleton()
	
}
