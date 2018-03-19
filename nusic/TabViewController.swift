//
//  TabViewController.swift
//  nusic
//
//  Created by SyotaTsuda on 2018/03/19.
//  Copyright © 2018年 Syota Tsuda. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController {
	
	enum Tag: Int {
		case tagPlayList
		case tagArtist
		case tagAlbum
		case tagSong
	}
	
	private var naviPlayList: UINavigationController!
	private var naviArtist: UINavigationController!
	private var naviAlbum: UINavigationController!
	private var naviSong: UINavigationController!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = UIColor.white
		
		naviPlayList = UINavigationController(rootViewController: PlayListTableViewController())
		naviArtist = UINavigationController(rootViewController: ArtistTableViewController())
		naviAlbum = UINavigationController(rootViewController: AlbumTableViewController())
		naviSong = UINavigationController(rootViewController: SongTableViewController())
		
		naviPlayList.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.featured, tag: Tag.tagPlayList.rawValue)
		naviArtist.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.featured, tag: Tag.tagArtist.rawValue)
		naviAlbum.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.featured, tag: Tag.tagAlbum.rawValue)
		naviSong.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.featured, tag: Tag.tagSong.rawValue)
		
		self.setViewControllers([naviPlayList!, naviArtist!, naviAlbum!, naviSong!], animated: false)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
}
