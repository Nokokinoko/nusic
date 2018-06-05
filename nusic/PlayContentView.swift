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
	
	@IBOutlet weak var _Artwork: UIImageView!
	
	@IBOutlet weak var _LabelSong: UILabel!
	@IBOutlet weak var _LabelAlbum: UILabel!
	@IBOutlet weak var _LabelArtist: UILabel!
	
	@IBOutlet weak var _CtrlPlay: UIButton!
	@IBOutlet weak var _CtrlNext: UIButton!
	@IBOutlet weak var _CtrlPrev: UIButton!
	
	@IBOutlet weak var _CtrlShuffle: UIButton!
	@IBOutlet weak var _LabelShuffle: UILabel!
	@IBOutlet weak var _CtrlRepeat: UIButton!
	@IBOutlet weak var _LabelRepeat: UILabel!
	@IBOutlet weak var _CtrlTimer: UIButton!
	@IBOutlet weak var _LabelTimer: UILabel!
	
	fileprivate var _Picker: [Float] = [0.5, 1.0, 1.5, 2.0, 2.5, 3.0]
	fileprivate var _SelectingSettingTimer: Float = 1.0
	private var _UpdateTimer = Timer()
	
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
		
		_CtrlPlay.addTarget(self, action: #selector(PlayContentView.touchPlay), for: .touchUpInside)
		_CtrlNext.addTarget(self, action: #selector(PlayContentView.touchNext), for: .touchUpInside)
		_CtrlPrev.addTarget(self, action: #selector(PlayContentView.touchPrev), for: .touchUpInside)
		
		_CtrlShuffle.addTarget(self, action: #selector(PlayContentView.touchShuffle), for: .touchUpInside)
		_CtrlRepeat.addTarget(self, action: #selector(PlayContentView.touchRepeat), for: .touchUpInside)
		_CtrlTimer.addTarget(self, action: #selector(PlayContentView.touchTimer), for: .touchUpInside)
		
		let buttonLongPress = UILongPressGestureRecognizer(target: self, action: #selector(PlayContentView.longPressTimer(sender:)))
		buttonLongPress.minimumPressDuration = 2.0
		buttonLongPress.allowableMovement = 20
		_CtrlTimer.addGestureRecognizer(buttonLongPress)
		
		let notification = NotificationCenter.default
		notification.addObserver(
			self,
			selector: #selector(PlayContentView.changeItem),
			name: .MPMusicPlayerControllerPlaybackStateDidChange,
			object: Singleton.sharedInstance.getPlayer()
		)
		notification.addObserver(
			self,
			selector: #selector(PlayContentView.changeItem),
			name: .MPMusicPlayerControllerNowPlayingItemDidChange,
			object: Singleton.sharedInstance.getPlayer()
		)
		Singleton.sharedInstance.getPlayer().beginGeneratingPlaybackNotifications()
		
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
			object: Singleton.sharedInstance.getPlayer()
		)
		notification.removeObserver(
			self,
			name: .MPMusicPlayerControllerNowPlayingItemDidChange,
			object: Singleton.sharedInstance.getPlayer()
		)
		_Player.endGeneratingPlaybackNotifications()
	}
	*/
	
	override func prepareForInterfaceBuilder() {
		setup()
	}
	
	@objc private func updateOffTimer() {
		if _UpdateTimer.isValid {
			if Singleton.sharedInstance.progressOneSec() {
				// to STOP
				stopPlay()
				_UpdateTimer.invalidate()
			}
		}
		else {
			_UpdateTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PlayContentView.updateOffTimer), userInfo: nil, repeats: true)
		}
	}
	
	// ---------------------------------------------------------------------------
	// Play
	public func play() {
		if let query = Singleton.sharedInstance.getPlayQuery() {
			Singleton.sharedInstance.getPlayer().setQueue(with: query)
			if Singleton.sharedInstance.isSetPlayItem() {
				Singleton.sharedInstance.getPlayer().nowPlayingItem = Singleton.sharedInstance.getPlayItem()
			}
			
			Singleton.sharedInstance.getPlayer().shuffleMode = Singleton.sharedInstance.getPlayShuffle() ? .songs : .default
			Singleton.sharedInstance.getPlayer().play()
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
			stopPlay()
		}
		else {
			Singleton.sharedInstance.getPlayer().play()
			_CtrlPlay.setImage(Define.ImagePause, for: .normal)
		}
	}
	
	private func stopPlay() {
		Singleton.sharedInstance.getPlayer().pause()
		_CtrlPlay.setImage(Define.ImagePlay, for: .normal)
	}
	
	// ---------------------------------------------------------------------------
	// Next
	@objc func touchNext() {
		Singleton.sharedInstance.getPlayer().skipToNextItem()
	}
	
	// ---------------------------------------------------------------------------
	// Prev
	@objc func touchPrev() {
		if 3 < Singleton.sharedInstance.getPlayer().currentPlaybackTime {
			Singleton.sharedInstance.getPlayer().skipToBeginning()
		}
		else {
			Singleton.sharedInstance.getPlayer().skipToPreviousItem()
		}
	}
	
	// ---------------------------------------------------------------------------
	// Shuffle
	private func resetCtrlShuffle() {
		switch Singleton.sharedInstance.getPlayer().shuffleMode {
		case .off:
			_CtrlShuffle.setImage(Define.ImageShuffleOff, for: .normal)
			_LabelShuffle.text = "Shuffle OFF";
			_LabelShuffle.textColor = Define.ColorGray
		case .songs:
			_CtrlShuffle.setImage(Define.ImageShuffleOn, for: .normal)
			_LabelShuffle.text = "Shuffle ON";
			_LabelShuffle.textColor = Define.ColorPink
		default: break
		}
	}
	
	@objc func touchShuffle() {
		Singleton.sharedInstance.changePlayerShuffle()
		resetCtrlShuffle()
	}
	
	// ---------------------------------------------------------------------------
	// Repeat
	private func resetCtrlRepeat() {
		switch Singleton.sharedInstance.getPlayer().repeatMode {
		case .none:
			_CtrlRepeat.setImage(Define.ImageRepeatOff, for: .normal)
			_LabelRepeat.text = "Repeat OFF"
			_LabelRepeat.textColor = Define.ColorGray
		case .all:
			_CtrlRepeat.setImage(Define.ImageRepeatOn, for: .normal)
			_LabelRepeat.text = "Repeat ALL"
			_LabelRepeat.textColor = Define.ColorPink
		case .one:
			_CtrlRepeat.setImage(Define.ImageRepeatOne, for: .normal)
			_LabelRepeat.text = "Repeat 1"
			_LabelRepeat.textColor = Define.ColorPink
		default: break
		}
	}
	
	@objc func touchRepeat() {
		Singleton.sharedInstance.changePlayerRepeat()
		resetCtrlRepeat()
	}
	
	// ---------------------------------------------------------------------------
	// Timer
	private func convOffTimer() -> String {
		var timer: Int = Singleton.sharedInstance.getOffTimer()
		if timer <= 0 {
			return "OFF";
		}
		timer += 10;
		return String(Int(timer / 3600)) + "H" + String(format: "%02d", (timer % 3600) / 60) + "M"
	}
	
	private func resetCtrlTimer() {
		if Singleton.sharedInstance.isTimer() {
			if Singleton.sharedInstance.getOffTimer() <= 0 {
				touchTimer() // to OFF
				return;
			}
			_CtrlTimer.setImage(Define.ImageTimerOn, for: .normal)
			_LabelTimer.text = "Timer " + convOffTimer()
			_LabelTimer.textColor = Define.ColorPink
			
			updateOffTimer()
		}
		else {
			if _UpdateTimer.isValid {
				_UpdateTimer.invalidate()
			}
			_CtrlTimer.setImage(Define.ImageTimerOff, for: .normal)
			_LabelTimer.text = "Timer OFF"
			_LabelTimer.textColor = Define.ColorGray
		}
	}
	
	@objc func touchTimer() {
		Singleton.sharedInstance.toggleIsTimer()
		resetCtrlTimer()
	}
	
	override var canBecomeFirstResponder: Bool {
		return true
	}
	
	@objc func longPressTimer(sender: UILongPressGestureRecognizer) {
		_SelectingSettingTimer = Singleton.sharedInstance.getSettingTimer()
		becomeFirstResponder()
	}
	
	override var inputView: UIView? {
		let view = UIPickerView()
		view.delegate = self
		let row = _Picker.index(of: _SelectingSettingTimer) ?? 1
		view.selectRow(row, inComponent: 0, animated: false)
		return view
	}
	
	override var inputAccessoryView: UIView? {
		let button = UIButton(type: .system)
		button.setTitle(NSLocalizedString("done", tableName: Define.NameLocalizedString, comment: ""), for: .normal)
		button.addTarget(self, action: #selector(PlayContentView.doneTimer(sender:)), for: .touchDown)
		button.sizeToFit()
		
		let view = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 44))
		view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		view.backgroundColor = .groupTableViewBackground
		
		button.frame.origin.x = view.frame.size.width - button.frame.size.width - 16
		button.center.y = view.center.y
		button.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin, .flexibleTopMargin]
		view.addSubview(button)
		
		return view
	}
	
	@objc func doneTimer(sender: UIButton) {
		Singleton.sharedInstance.setSettingTimer(setting: _SelectingSettingTimer)
		resignFirstResponder()
	}
	
	// ---------------------------------------------------------------------------
	public func resetAll() {
		resetCtrlPlay()
		resetCtrlShuffle()
		resetCtrlRepeat()
		resetCtrlTimer()
	}
	
	@objc func changeItem(notification: Notification) {
		if let item = Singleton.sharedInstance.getPlayer().nowPlayingItem {
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
		info?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = Singleton.sharedInstance.getPlayer().currentPlaybackTime
	}

}

extension PlayContentView: UIKeyInput {
	
	var hasText: Bool {
		return true;
	}
	
	func insertText(_ text: String) {}
	
	func deleteBackward() {}
	
}

extension PlayContentView: UIPickerViewDelegate, UIPickerViewDataSource {
	
	// データ数
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return _Picker.count
	}
	
	// 列数
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	// 表示データを返す
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return String(format: "%.1f", _Picker[row]) + "H"
	}
	
	// データ選択
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		_SelectingSettingTimer = _Picker[row]
	}
	
}
