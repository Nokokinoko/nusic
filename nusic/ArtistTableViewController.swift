//
//  ArtistTableViewController.swift
//  nusic
//
//  Created by SyotaTsuda on 2018/03/17.
//  Copyright © 2018年 Syota Tsuda. All rights reserved.
//

import UIKit
import MediaPlayer

class ArtistTableViewController: AbstractTableViewController {
	
	override func getName() -> String {
		return "Artist"
	}
	
	override func getMediaQuery() -> MPMediaQuery? {
		let query = MPMediaQuery.artists()
		query.addFilterPredicate(MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem))
		return query
	}
	
	override func setDataCell(cell: inout UITableViewCell, item: MPMediaItem) {
		let artwork = item.artwork
		cell.imageView?.image = artwork?.image(at: (cell.imageView?.bounds.size)!)
		cell.textLabel?.text = item.value(forProperty: MPMediaItemPropertyArtist) as? String
	}
	
	override func onSelect(indexPath: IndexPath) -> UIViewController? {
		let vcSong = SongTableViewController()
		vcSong.callFromArtist(filter: "")
		return vcSong
	}
	
}
