//
//  PlayViewController.swift
//  nusic
//
//  Created by SyotaTsuda on 2018/03/21.
//  Copyright © 2018年 Syota Tsuda. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController {
	
	private var _Touch: Bool = false
	private var _Dismiss: Bool = false
	open var isReserve: Bool = false
	
	private var _Blur: UIVisualEffectView!
	private var _View: PlayContentView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		_Touch = false
		_Dismiss = false
		
		_Blur = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.dark))
		_Blur.frame = self.view.frame
		_Blur.alpha = 0.0
		self.view.addSubview(_Blur)
		
		_View = PlayContentView(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
		_View.center = _Blur.center
		_Blur.addSubview(_View)
		
		if isReserve {
			_View.play()
			isReserve = false
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		UIView.animate(
			withDuration: 0.25,
			animations: { self._Blur.alpha = 1.0 }
		)
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		let point = touches.first?.location(in: self.view)
		if !_View.frame.contains(point!) {
			_Touch = true
		}
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		if !_Touch {
			return
		}
		_Touch = false
		
		if _Dismiss {
			return
		}
		
		let point = touches.first?.location(in: self.view)
		if !_View.frame.contains(point!) {
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
