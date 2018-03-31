//
//  SongTableViewController.swift
//  nusic
//
//  Created by SyotaTsuda on 2018/03/17.
//  Copyright © 2018年 Syota Tsuda. All rights reserved.
//

import UIKit
import MediaPlayer

class SongTableViewController: AbstractTableVC {
	
	private enum CALL_FROM {
		case NONE
		case PLAY_LIST
		case ARTIST
		case ALBUM
	}
	private var _CallFrom: CALL_FROM = CALL_FROM.NONE
	private var _PersistentID: MPMediaEntityPersistentID = 0 // UInt64
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		_HaveBack = (_CallFrom != CALL_FROM.NONE)
		resetBtnLeft()
	}
	
	public func callFromPlayList(persistentID: MPMediaEntityPersistentID) {
		_CallFrom = CALL_FROM.PLAY_LIST
		_PersistentID = persistentID
	}
	
	public func isFilterPlayList() -> Bool {
		return _CallFrom == CALL_FROM.PLAY_LIST
	}
	
	public func callFromArtist(persistentID: MPMediaEntityPersistentID) {
		_CallFrom = CALL_FROM.ARTIST
		_PersistentID = persistentID
	}
	
	public func isFilterArtist() -> Bool {
		return _CallFrom == CALL_FROM.ARTIST
	}
	
	public func callFromAlbum(persistentID: MPMediaEntityPersistentID) {
		_CallFrom = CALL_FROM.ALBUM
		_PersistentID = persistentID
	}
	
	public func isFilterAlbum() -> Bool {
		return _CallFrom == CALL_FROM.ALBUM
	}
	
	public func getPersistentID() -> MPMediaEntityPersistentID {
		return _PersistentID
	}
	
	override func haveSection() -> Bool {
		return _CallFrom == CALL_FROM.NONE
	}
	
}

extension SongTableViewController: ProtocolTableVC {
	
	func getName() -> String {
		return "Song"
	}
	
	func getMediaQuery() -> MPMediaQuery {
		let query = MPMediaQuery.songs()
		var forProperty: String! = nil
		
		switch true {
		case isFilterPlayList():	query.groupingType = MPMediaGrouping.playlist;	forProperty = MPMediaPlaylistPropertyPersistentID
		case isFilterArtist():		query.groupingType = MPMediaGrouping.artist;	forProperty = MPMediaItemPropertyArtistPersistentID
		case isFilterAlbum():		query.groupingType = MPMediaGrouping.album;		forProperty = MPMediaItemPropertyAlbumPersistentID
		default: break
		}
		
		if forProperty != nil {
			query.addFilterPredicate(MPMediaPropertyPredicate(
				value: getPersistentID(),
				forProperty: forProperty
			))
		}
		query.addFilterPredicate(MPMediaPropertyPredicate(
			value: false,
			forProperty: MPMediaItemPropertyIsCloudItem
		))
		return query
	}
	
	func setDataCell(cell: inout UITableViewCell, item: MPMediaItem) {
		cell.imageView?.image = item.artwork?.image(at: (cell.imageView?.bounds.size)!)
		cell.textLabel?.text = item.value(forProperty: MPMediaItemPropertyTitle) as? String
		cell.detailTextLabel?.text = item.value(forProperty: MPMediaItemPropertyArtist) as? String
	}
	
	func onSelect(item: MPMediaItem) -> UIViewController {
		return PlayViewController()
	}
	
}
