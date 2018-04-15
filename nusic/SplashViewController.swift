//
//  SplashViewController.swift
//  nusic
//
//  Created by SyotaTsuda on 2018/04/15.
//  Copyright © 2018年 Syota Tsuda. All rights reserved.
//

import UIKit
import MediaPlayer

class SplashViewController: UIViewController {
	
	private var _Image: UIImageView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = Define.ColorBlack
		
		let image = UIImage(named: "Logo")!
		_Image = UIImageView(image: image)
		_Image.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
		_Image.center = self.view.center
		self.view.addSubview(_Image)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		UIView.animate(
			withDuration: 0.5,
			animations: { self._Image.transform = CGAffineTransform(scaleX: 1.0, y: 1.0) },
			completion: { _ in
				let requested: MPMediaLibraryAuthorizationStatus = MPMediaLibrary.authorizationStatus()
				if requested == .authorized {
					self.goMain()
				}
				else {
					MPMediaLibrary.requestAuthorization { (requesting: MPMediaLibraryAuthorizationStatus) in
						if requesting == .authorized {
							self.goMain()
						}
						else {
							let alert = UIAlertController(
								title: nil,
								message: NSLocalizedString("alert", tableName: Define.NameLocalizedString, comment: ""),
								preferredStyle: .alert
							)
							alert.addAction(UIAlertAction(title: "OK", style: .default))
							self.present(alert, animated: true, completion: nil)
						}
					}
				}
			}
		)
	}
	
	private func goMain() {
		UIView.animate(
			withDuration: 0.25,
			animations: {
				self._Image.alpha = 0.0
				self._Image.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
			},
			completion: { _ in
				let main = TabViewController()
				main.modalTransitionStyle = .crossDissolve
				self.present(main, animated: true, completion: nil)
			}
		)
	}
	
}
