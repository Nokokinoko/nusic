//
//  PlayContentView.swift
//  nusic
//
//  Created by SyotaTsuda on 2018/03/26.
//  Copyright © 2018年 Syota Tsuda. All rights reserved.
//

import UIKit
import MediaPlayer

class PlayContentView: UIView, MPMediaPickerControllerDelegate {
	
	private var _Player: MPMusicPlayerController!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	private func setup() {
		let viewPlay = UINib(nibName: "PlayContentView", bundle: Bundle(for: PlayContentView.self)).instantiate(withOwner: self, options: nil)[0] as! UIView
		viewPlay.frame = self.bounds
		addSubview(viewPlay)
		
		_Player = MPMusicPlayerController.systemMusicPlayer()
		
		let notification = NotificationCenter.default
		notification.addObserver(
			self,
			selector: #selector(PlayContentView.changeItem),
			name: .MPMusicPlayerControllerNowPlayingItemDidChange,
			object: _Player
		)
		_Player.beginGeneratingPlaybackNotifications()
	}
	
	deinit {
		let notification = NotificationCenter.default
		notification.removeObserver(
			self,
			name: .MPMusicPlayerControllerNowPlayingItemDidChange,
			object: _Player
		)
		_Player.endGeneratingPlaybackNotifications()
	}
	
	override func prepareForInterfaceBuilder() {
		setup()
	}
	
	public func play() {
		if let query = Singleton.sharedInstance.getPlayQuery() {
			_Player.setQueue(with: query)
			_Player.nowPlayingItem = Singleton.sharedInstance.getPlayItem()
			_Player.play()
		}
	}
	
	@objc func changeItem(notification: Notification) {
		// TODO: change item
	}

}
