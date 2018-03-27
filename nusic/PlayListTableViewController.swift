//
//  PlayListTableViewController.swift
//  nusic
//
//  Created by SyotaTsuda on 2018/03/17.
//  Copyright © 2018年 Syota Tsuda. All rights reserved.
//

import UIKit
import MediaPlayer

class PlayListTableViewController: AbstractTableViewController {
	
	override func getName() -> String {
		return "PlayList"
	}
	
	override func getMediaQuery() -> MPMediaQuery? {
		let query = MPMediaQuery.playlists()
		query.addFilterPredicate(MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem))
		return query
	}
	
	override func setDataCell(cell: inout UITableViewCell, item: MPMediaItem) {
		cell.textLabel?.text = item.value(forProperty: MPMediaPlaylistPropertyName) as? String
	}
	
	override func onSelect(indexPath: IndexPath) -> UIViewController? {
		let vcSong = SongTableViewController()
		vcSong.callFromPlayList(filter: "")
		return vcSong
	}
	
}
