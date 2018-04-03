//
//  AlbumTableViewController.swift
//  nusic
//
//  Created by SyotaTsuda on 2018/03/17.
//  Copyright © 2018年 Syota Tsuda. All rights reserved.
//

import UIKit
import MediaPlayer

class AlbumTableViewController: AbstractTableVC {}

extension AlbumTableViewController: ProtocolTableVC {
	
	func getName() -> String {
		return "Album"
	}
	
	func getMediaQuery() -> MPMediaQuery {
		let query = MPMediaQuery.albums()
		query.addFilterPredicate(MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem))
		return query
	}
	
	func setDataCell(cell: inout UITableViewCell, item: MPMediaItem) {
		if let artwork = item.artwork {
			cell.imageView?.image = artwork.image(at: (cell.imageView?.bounds.size)!)
		}
		else {
			cell.imageView?.image = Define.NoImage
		}
		cell.textLabel?.text = item.value(forProperty: MPMediaItemPropertyAlbumTitle) as? String
		cell.detailTextLabel?.text = item.value(forProperty: MPMediaItemPropertyAlbumArtist) as? String
	}
	
	func onSelect(item: MPMediaItem) -> AbstractTableVC {
		let vcSong = SongTableViewController()
		vcSong.callFromAlbum(persistentID: item.albumPersistentID)
		return vcSong
	}
	
}
