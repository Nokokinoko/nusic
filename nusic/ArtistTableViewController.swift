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
		cell.imageView?.image = item.artwork?.image(at: (cell.imageView?.bounds.size)!)
		cell.textLabel?.text = item.value(forProperty: MPMediaItemPropertyArtist) as? String
	}
	
	func onSelect(item: MPMediaItem) -> UIViewController {
		let vcSong = SongTableViewController()
		vcSong.callFromArtist(persistentID: item.persistentID) // MPMediaItemPropertyArtistPersistentID
		return vcSong
	}
	
}
