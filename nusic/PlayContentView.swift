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
			_Player.play()
			_CtrlPlay.setImage(Define.ImagePause, for: .normal)
		}
	}
	
	private func isPlaying() -> Bool {
		return AVAudioSession.sharedInstance().isOtherAudioPlaying
	}
	
	private func resetCtrlPlay() {
		if isPlaying() {
			_CtrlPlay.setImage(Define.ImagePause, for: .normal)
		}
		else {
			_CtrlPlay.setImage(Define.ImagePlay, for: .normal)
		}
	}
	
	@objc func touchPlay() {
		if isPlaying() {
			_Player.pause()
			_CtrlPlay.setImage(Define.ImagePlay, for: .normal)
		}
		else {
			_Player.play()
			_CtrlPlay.setImage(Define.ImagePause, for: .normal)
		}
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
	
	private func resetCtrlRepeat() {
		switch _Player.repeatMode {
		case .none:	_CtrlRepeat.setImage(Define.ImageRepeatOff, for: .normal)
		case .all:	_CtrlRepeat.setImage(Define.ImageRepeatOn, for: .normal)
		case .one:	_CtrlRepeat.setImage(Define.ImageRepeatOne, for: .normal)
		default: break
		}
	}
	
	@objc func touchRepeat() {
		switch _Player.repeatMode {
		case .none:	_Player.repeatMode = .all
		case .all:	_Player.repeatMode = .one
		case .one:	_Player.repeatMode = .none
		default: break
		}
		resetCtrlRepeat()
	}
	
	private func resetCtrlShuffle() {
		switch _Player.shuffleMode {
		case .off:		_CtrlShuffle.setImage(Define.ImageShuffleOff, for: .normal)
		case .songs:	_CtrlShuffle.setImage(Define.ImageShuffleOn, for: .normal)
		default: break
		}
	}
	
	@objc func touchShuffle() {
		switch _Player.shuffleMode {
		case .off:		_Player.shuffleMode = .songs
		case .songs:	_Player.shuffleMode = .off
		default: break
		}
		resetCtrlShuffle()
	}
	
	public func resetAll() {
		resetCtrlPlay()
		resetCtrlRepeat()
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
		
		if let artwork = item.artwork {
			info?[MPMediaItemPropertyArtwork] = artwork
			_Artwork.image = artwork.image(at: _Artwork.bounds.size)
		}
		else {
			info?[MPMediaItemPropertyArtwork] = Define.NoImage
			_Artwork.image = Define.NoImage
		}
		
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
