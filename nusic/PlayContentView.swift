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
	
	@IBOutlet weak var _Artwork: UIImageView!
	
	@IBOutlet weak var _LabelSong: UILabel!
	@IBOutlet weak var _LabelAlbum: UILabel!
	@IBOutlet weak var _LabelArtist: UILabel!
	
	@IBOutlet weak var _CtrlPlay: UIButton!
	@IBOutlet weak var _CtrlNext: UIButton!
	@IBOutlet weak var _CtrlPrev: UIButton!
	@IBOutlet weak var _CtrlRepeat: UIButton!
	@IBOutlet weak var _CtrlShuffle: UIButton!
	
	private let _ImagePlay: UIImage = UIImage(named: "CtrlPlay")!
	private let _ImagePause: UIImage = UIImage(named: "CtrlPause")!
	private let _ImageNext: UIImage = UIImage(named: "CtrlNext")!
	private let _ImagePrev: UIImage = UIImage(named: "CtrlPrev")!
	private let _ImageRepeatOn: UIImage = UIImage(named: "CtrlRepeatOn")!
	private let _ImageRepeatOne: UIImage = UIImage(named: "CtrlRepeatOne")!
	private let _ImageRepeatOff: UIImage = UIImage(named: "CtrlRepeatOff")!
	private let _ImageShuffleOn: UIImage = UIImage(named: "CtrlShuffleOn")!
	private let _ImageShuffleOff: UIImage = UIImage(named: "CtrlShuffleOff")!
	
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
		
		_CtrlPlay.addTarget(self, action: #selector(PlayContentView.touchPlay), for: .touchUpInside)
		_CtrlNext.addTarget(self, action: #selector(PlayContentView.touchNext), for: .touchUpInside)
		_CtrlPrev.addTarget(self, action: #selector(PlayContentView.touchPrev), for: .touchUpInside)
		_CtrlRepeat.addTarget(self, action: #selector(PlayContentView.touchRepeat), for: .touchUpInside)
		_CtrlShuffle.addTarget(self, action: #selector(PlayContentView.touchShuffle), for: .touchUpInside)
		
		resetCtrlPlay()
		
		let notification = NotificationCenter.default
		notification.addObserver(
			self,
			selector: #selector(PlayContentView.changeItem),
			name: .MPMusicPlayerControllerPlaybackStateDidChange,
			object: _Player
		)
		notification.addObserver(
			self,
			selector: #selector(PlayContentView.changeItem),
			name: .MPMusicPlayerControllerNowPlayingItemDidChange,
			object: _Player
		)
		_Player.beginGeneratingPlaybackNotifications()
		
		let cmd = MPRemoteCommandCenter.shared()
		cmd.playCommand.addTarget(self, action: #selector(PlayContentView.touchPlay))
		cmd.playCommand.isEnabled = true
		cmd.pauseCommand.addTarget(self, action: #selector(PlayContentView.touchPlay))
		cmd.pauseCommand.isEnabled = true
		cmd.togglePlayPauseCommand.addTarget(self, action: #selector(PlayContentView.touchPlay))
		cmd.togglePlayPauseCommand.isEnabled = true
		cmd.skipForwardCommand.addTarget(self, action: #selector(PlayContentView.touchNext))
		cmd.skipForwardCommand.isEnabled = true
		cmd.skipBackwardCommand.addTarget(self, action: #selector(PlayContentView.touchPrev))
		cmd.skipBackwardCommand.isEnabled = true
	}
	
	/*
	deinit {
		let notification = NotificationCenter.default
		notification.removeObserver(
			self,
			name: .MPMusicPlayerControllerPlaybackStateDidChange,
			object: _Player
		)
		notification.removeObserver(
			self,
			name: .MPMusicPlayerControllerNowPlayingItemDidChange,
			object: _Player
		)
		_Player.endGeneratingPlaybackNotifications()
	}
	*/
	
	override func prepareForInterfaceBuilder() {
		setup()
	}
	
	public func play() {
		if let query = Singleton.sharedInstance.getPlayQuery() {
			_Player.setQueue(with: query)
			if Singleton.sharedInstance.isSetPlayItem() {
				_Player.nowPlayingItem = Singleton.sharedInstance.getPlayItem()
			}
			
			_Player.shuffleMode = Singleton.sharedInstance.getPlayShuffle() ? .songs : .default
			resetCtrlShuffle()
			
			_Player.play()
			resetCtrlPlay()
		}
	}
	
	private func resetCtrlPlay() {
		switch _Player.playbackState {
		case .playing:
			_CtrlPlay.setImage(_ImagePlay, for: .normal)
		case .paused:
			_CtrlPlay.setImage(_ImagePause, for: .normal)
		default: break
		}
	}
	
	@objc func touchPlay() {
		switch _Player.playbackState {
		case .playing:	_Player.pause()
		case .paused:	_Player.play()
		default: break
		}
		resetCtrlPlay()
	}
	
	@objc func touchNext() {
		_Player.skipToNextItem()
	}
	
	@objc func touchPrev() {
		if 3 < _Player.currentPlaybackTime {
			_Player.skipToBeginning()
		}
		else {
			_Player.skipToPreviousItem()
		}
	}
	
	@objc func touchRepeat() {
		switch _Player.repeatMode {
		case .none:
			_Player.repeatMode = .all
			_CtrlRepeat.setImage(_ImageRepeatOn, for: .normal)
			_CtrlRepeat.tintColor = Define.ColorPink
		case .all:
			_Player.repeatMode = .one
			_CtrlRepeat.setImage(_ImageRepeatOne, for: .normal)
		case .one:
			_Player.repeatMode = .none
			_CtrlRepeat.setImage(_ImageRepeatOff, for: .normal)
			_CtrlRepeat.tintColor = Define.ColorGray
		default: break
		}
	}
	
	private func resetCtrlShuffle() {
		switch _Player.shuffleMode {
		case .off:
			_CtrlShuffle.setImage(_ImageShuffleOff, for: .normal)
		case .songs:
			_CtrlShuffle.setImage(_ImageShuffleOn, for: .normal)
		default: break
		}
	}
	
	@objc func touchShuffle() {
		switch _Player.shuffleMode {
		case .off:
			_Player.shuffleMode = .songs
		case .songs:
			_Player.shuffleMode = .off
		default: break
		}
		resetCtrlShuffle()
	}
	
	@objc func changeItem(notification: Notification) {
		if let item = _Player.nowPlayingItem {
			Singleton.sharedInstance.setPlayItem(item: item)
			setPlayingItem(item: item)
		}
	}
	
	public func setPlayingItem(item: MPMediaItem) {
		var info = MPNowPlayingInfoCenter.default().nowPlayingInfo
		
		info?[MPMediaItemPropertyArtwork] = item.artwork
		_Artwork.image = item.artwork?.image(at: _Artwork.bounds.size)
		
		let song = item.title == nil ? "-" : item.title
		info?[MPMediaItemPropertyTitle] = song
		_LabelSong.text = song
		
		let album = item.albumTitle == nil ? "-" : item.albumTitle
		_LabelAlbum.text = album
		
		let artist = item.artist == nil ? "-" : item.artist
		info?[MPMediaItemPropertyArtist] = artist
		_LabelArtist.text = artist
		
		info?[MPNowPlayingInfoPropertyPlaybackRate] = 1.0
		info?[MPMediaItemPropertyPlaybackDuration] = item.playbackDuration
		info?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = _Player.currentPlaybackTime
	}

}
