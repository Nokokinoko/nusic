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
		case PLAY_LIST
		case ARTIST
		case ALBUM
		case SONG
		case PLAY
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
		
		_NaviPlayList.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.featured, tag: TAG.PLAY_LIST.rawValue)
		_NaviArtist.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.featured, tag: TAG.ARTIST.rawValue)
		_NaviAlbum.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.featured, tag: TAG.ALBUM.rawValue)
		_NaviSong.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.featured, tag: TAG.SONG.rawValue)
		_NaviPlay.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.featured, tag: TAG.PLAY.rawValue)
		
		self.setViewControllers([_NaviPlayList!, _NaviArtist!, _NaviAlbum!, _NaviSong!, _NaviPlay!], animated: false)
		self.delegate = self
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
		if viewController is DummyViewController {
			let vcPlay = PlayViewController()
			vcPlay.modalPresentationStyle = .overCurrentContext
			self.present(vcPlay, animated: false, completion: nil)
			return false
		}
		return true
	}
	
}
