//
//  PlayListTableViewController.swift
//  nusic
//
//  Created by SyotaTsuda on 2018/03/17.
//  Copyright © 2018年 Syota Tsuda. All rights reserved.
//

import UIKit
import MediaPlayer

class PlayListTableViewController: AbstractTableVC {
	
	override func haveSection() -> Bool {
		return false
	}
	
}

extension PlayListTableViewController: ProtocolTableVC {
	
	func getName() -> String {
		return "PlayList"
	}
	
	func getMediaQuery() -> MPMediaQuery {
		let query = MPMediaQuery.playlists()
		query.addFilterPredicate(MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem))
		return query
	}
	
	func setDataCell(cell: inout UITableViewCell, item: MPMediaItem) {
		cell.textLabel?.text = item.value(forProperty: MPMediaPlaylistPropertyName) as? String
	}
	
	func onSelect(item: MPMediaItem) -> UIViewController {
		let vcSong = SongTableViewController()
		vcSong.callFromPlayList(persistentID: item.persistentID) // MPMediaPlaylistPropertyPersistentID
		return vcSong
	}
	
}
