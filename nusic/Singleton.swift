//
//  Singleton.swift
//  nusic
//
//  Created by SyotaTsuda on 2018/03/17.
//  Copyright © 2018年 Syota Tsuda. All rights reserved.
//

import Foundation
import MediaPlayer

final class Singleton {
	
	static let sharedInstance = Singleton()
	
	private var _PlayQuery: MPMediaQuery!
	private var _PlayItem: MPMediaItem!
	
	private init() {}
	
	public func initPlayProperty() {
		_PlayQuery = nil
		_PlayItem = nil
	}
	
	public func setPlayQuery(query: MPMediaQuery) {
		_PlayQuery = query
	}
	
	public func getPlayQuery() -> MPMediaQuery? {
		return _PlayQuery
	}
	
	public func setPlayItem(item: MPMediaItem) {
		_PlayItem = item
	}
	
	public func getPlayItem() -> MPMediaItem? {
		return _PlayItem
	}
	
	public func isSetPlayItem() -> Bool {
		return _PlayItem != nil
	}
	
}
