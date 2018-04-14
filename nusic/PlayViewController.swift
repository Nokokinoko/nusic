//
//  PlayViewController.swift
//  nusic
//
//  Created by SyotaTsuda on 2018/03/21.
//  Copyright © 2018年 Syota Tsuda. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController {
	
	private var _Dismiss: Bool = false
	open var isReserve: Bool = false
	
	private var _Blur: UIVisualEffectView!
	private var _Play: PlayContentView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		_Dismiss = false
		
		// Tap
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(
			target: self,
			action: #selector(PlayViewController.gestureTap(sender:))
		)
		tap.numberOfTapsRequired = 1
		self.view.addGestureRecognizer(tap)
		
		// Swipe Down
		let swipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(
			target: self,
			action: #selector(PlayViewController.gestureSwipeDown(sender:))
		)
		swipe.numberOfTouchesRequired = 1
		swipe.direction = .down
		self.view.addGestureRecognizer(swipe)
		
		_Blur = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.dark))
		_Blur.frame = self.view.frame
		_Blur.alpha = 0.0
		self.view.addSubview(_Blur)
		
		_Play = PlayContentView(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
		_Play.center = _Blur.center
		_Blur.addSubview(_Play)
		
		if isReserve {
			_Play.play()
			isReserve = false
		}
		else {
			_Play.setPlayingItem(item: Singleton.sharedInstance.getPlayItem()!)
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		_Play.resetAll()
		UIView.animate(
			withDuration: 0.25,
			animations: { self._Blur.alpha = 1.0 }
		)
	}
	
	@objc func gestureTap(sender: UITapGestureRecognizer) {
		if sender.state == .ended {
			if _Dismiss {
				return
			}
			
			let point = sender.location(in: self.view)
			if !_Play.frame.contains(point) {
				_Dismiss = true
				
				let parent = presentingViewController as! TabViewController
				parent.updateTab()
				
				UIView.animate(
					withDuration: 0.25,
					animations: { self._Blur.alpha = 0.0 },
					completion: { _ in self.dismiss(animated: false, completion: nil) }
				)
			}
		}
	}
	
	@objc func gestureSwipeDown(sender: UISwipeGestureRecognizer) {
		if _Dismiss {
			return
		}
		_Dismiss = true
		
		let parent = presentingViewController as! TabViewController
		parent.updateTab()
		
		UIView.animate(
			withDuration: 0.25,
			animations: {
				self._Blur.alpha = 0.0
				self._Play.center.y += 100.0
			},
			completion: { _ in self.dismiss(animated: false, completion: nil) }
		)
	}
	
}
