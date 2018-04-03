//
//  TabViewController.swift
//  nusic
//
//  Created by SyotaTsuda on 2018/03/19.
//  Copyright © 2018年 Syota Tsuda. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController, UITabBarControllerDelegate {
	
	private enum TAG: Int {
		case PLAY_LIST = 0
		case ARTIST = 1
		case ALBUM = 2
		case SONG = 3
		case PLAY = 4
	}
	
	class DummyViewController: UIViewController {}
	
	private var _NaviPlayList: UINavigationController!
	private var _NaviArtist: UINavigationController!
	private var _NaviAlbum: UINavigationController!
	private var _NaviSong: UINavigationController!
	private var _NaviPlay: DummyViewController!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = UIColor.white
		
		_NaviPlayList = UINavigationController(rootViewController: PlayListTableViewController())
		_NaviArtist = UINavigationController(rootViewController: ArtistTableViewController())
		_NaviAlbum = UINavigationController(rootViewController: AlbumTableViewController())
		_NaviSong = UINavigationController(rootViewController: SongTableViewController())
		_NaviPlay = DummyViewController()
		
		self.tabBar.unselectedItemTintColor = Define.ColorGray
		self.tabBar.tintColor = Define.ColorBlue
		self.tabBar.barTintColor = Define.ColorBlack
		UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: Define.ColorGray], for: UIControlState.normal)
		UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: Define.ColorBlue], for: UIControlState.selected)
		
		_NaviPlayList.tabBarItem = UITabBarItem(title: "PlayList", image: UIImage(named: "TabPlayList"), tag: TAG.PLAY_LIST.rawValue)
		_NaviArtist.tabBarItem = UITabBarItem(title: "Artist", image: UIImage(named: "TabArtist"), tag: TAG.ARTIST.rawValue)
		_NaviAlbum.tabBarItem = UITabBarItem(title: "Album", image: UIImage(named: "TabAlbum"), tag: TAG.ALBUM.rawValue)
		_NaviSong.tabBarItem = UITabBarItem(title: "Song", image: UIImage(named: "TabSong"), tag: TAG.SONG.rawValue)
		_NaviPlay.tabBarItem = UITabBarItem(title: "Play", image: UIImage(named: "TabPlay"), tag: TAG.PLAY.rawValue)
		
		self.setViewControllers([_NaviPlayList!, _NaviArtist!, _NaviAlbum!, _NaviSong!, _NaviPlay!], animated: false)
		self.delegate = self
		
		updateTab()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	public func updateTab() {
		self.tabBar.items?[TAG.PLAY.rawValue].isEnabled = Singleton.sharedInstance.isSetPlayItem()
	}
	
	func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
		if viewController is DummyViewController && Singleton.sharedInstance.isSetPlayItem() {
			let vcPlay = PlayViewController()
			vcPlay.modalPresentationStyle = .overCurrentContext
			self.present(vcPlay, animated: false, completion: nil)
			return false
		}
		return true
	}
	
}
