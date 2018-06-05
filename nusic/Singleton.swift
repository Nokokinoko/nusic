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
	
	private var _Player: MPMusicPlayerController = MPMusicPlayerController.systemMusicPlayer()
	private var _PlayQuery: MPMediaQuery!
	private var _PlayItem: MPMediaItem!
	private var _PlayShuffle: Bool = false
	private var _OffTimer: Int = 0
	
	private init() {}
	
	// Player
	public func getPlayer() -> MPMusicPlayerController {
		return _Player
	}
	
	public func changePlayerShuffle() {
		switch _Player.shuffleMode {
		case .off:		_Player.shuffleMode = .songs
		case .songs:	_Player.shuffleMode = .off
		default: break
		}
	}
	
	public func changePlayerRepeat() {
		switch _Player.repeatMode {
		case .none:	_Player.repeatMode = .all
		case .all:	_Player.repeatMode = .one
		case .one:	_Player.repeatMode = .none
		default: break
		}
	}
	
	// Query
	public func setPlayQuery(query: MPMediaQuery) {
		_PlayQuery = query
	}
	
	public func getPlayQuery() -> MPMediaQuery? {
		return _PlayQuery
	}
	
	// Item
	public func setPlayItem(item: MPMediaItem?) {
		_PlayItem = item
	}
	
	public func getPlayItem() -> MPMediaItem? {
		return _PlayItem
	}
	
	public func isSetPlayItem() -> Bool {
		return _PlayItem != nil
	}
	
	// Shuffle
	public func setPlayShuffle(shuffle: Bool) {
		_PlayShuffle = shuffle
	}
	
	public func getPlayShuffle() -> Bool {
		return _PlayShuffle
	}
	
	// SettingTimer
	public func setSettingTimer(setting: Float) {
		UserDefaults.standard.set(setting, forKey: Define.KeySettingTimer)
		if isTimer() {
			setOffTimer(setting: setting)
		}
	}
	
	public func getSettingTimer() -> Float {
		var setting: Float = 1.0;
		if UserDefaults.standard.object(forKey: Define.KeySettingTimer) == nil {
			setSettingTimer(setting: setting)
		}
		else {
			setting = UserDefaults.standard.float(forKey: Define.KeySettingTimer)
		}
		return setting
	}
	
	// IsTimer
	public func isTimer() -> Bool {
		var flgTimer: Bool = false;
		if UserDefaults.standard.object(forKey: Define.KeyIsTimer) == nil {
			UserDefaults.standard.set(flgTimer, forKey: Define.KeyIsTimer)
		}
		else {
			flgTimer = UserDefaults.standard.bool(forKey: Define.KeyIsTimer)
		}
		return flgTimer
	}
	
	public func toggleIsTimer() {
		let flgTimer: Bool = !isTimer()
		UserDefaults.standard.set(flgTimer, forKey: Define.KeyIsTimer)
		if flgTimer {
			setOffTimer(setting: getSettingTimer())
		}
	}
	
	// OffTimer
	private func setOffTimer(setting: Float) {
		_OffTimer = Int(setting * 3600) // 60 * 60
	}
	
	public func getOffTimer() -> Int {
		return _OffTimer
	}
	
	public func progressOneSec() -> Bool {
		_OffTimer -= 1
		return _OffTimer <= 0
	}
	
}
