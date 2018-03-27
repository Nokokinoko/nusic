//
//  SongTableViewController.swift
//  nusic
//
//  Created by SyotaTsuda on 2018/03/17.
//  Copyright © 2018年 Syota Tsuda. All rights reserved.
//

import UIKit
import MediaPlayer

class SongTableViewController: AbstractTableViewController {
	
	private enum CALL_FROM {
		case NONE
		case PLAY_LIST
		case ARTIST
		case ALBUM
	}
	private var _CallFrom: CALL_FROM = CALL_FROM.NONE
	private var _Filter: String?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		_HaveBack = (_CallFrom != CALL_FROM.NONE)
		resetBtnLeft()
	}
	
	// >>> Call
	public func callFromPlayList(filter: String) {
		_CallFrom = CALL_FROM.PLAY_LIST
		_Filter = filter
	}
	
	public func callFromArtist(filter: String) {
		_CallFrom = CALL_FROM.ARTIST
		_Filter = filter
	}
	
	public func callFromAlbum(filter: String) {
		_CallFrom = CALL_FROM.ALBUM
		_Filter = filter
	}
	// <<< Call
	
	override func getName() -> String {
		return "Song"
	}
	
	override func getMediaQuery() -> MPMediaQuery? {
		let query = MPMediaQuery.songs()
		query.addFilterPredicate(MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem))
		return query
	}
	
	override func setDataCell(cell: inout UITableViewCell, item: MPMediaItem) {
		let artwork = item.artwork
		cell.imageView?.image = artwork?.image(at: (cell.imageView?.bounds.size)!)
		cell.textLabel?.text = item.value(forProperty: MPMediaItemPropertyTitle) as? String
		cell.detailTextLabel?.text = item.value(forProperty: MPMediaItemPropertyArtist) as? String
	}
	
	override func onSelect(indexPath: IndexPath) -> UIViewController? {
		let vcPlay = PlayViewController()
		// TODO: send song
		return vcPlay
	}
	
}
