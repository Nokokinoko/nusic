//
//  ArtistTableViewController.swift
//  nusic
//
//  Created by SyotaTsuda on 2018/03/17.
//  Copyright © 2018年 Syota Tsuda. All rights reserved.
//

import UIKit
import MediaPlayer

class ArtistTableViewController: AbstractTableVC {}

extension ArtistTableViewController: ProtocolTableVC {
	
	func getName() -> String {
		return "Artist"
	}
	
	func getMediaQuery() -> MPMediaQuery {
		let query = MPMediaQuery.artists()
		query.addFilterPredicate(MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem))
		return query
	}
	
	func setDataCell(cell: inout UITableViewCell, item: MPMediaItem) {
		cell.textLabel?.text = item.value(forProperty: MPMediaItemPropertyArtist) as? String
	}
	
	func onSelect(item: MPMediaItem) -> AbstractTableVC {
		let vcSong = SongTableViewController()
		vcSong.callFromArtist(persistentID: item.artistPersistentID)
		return vcSong
	}
	
}
