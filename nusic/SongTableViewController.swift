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
		case PLAY_LIST
		case ARTIST
		case ALBUM
		case SONG
	}
	private var _CallFrom: CALL_FROM = CALL_FROM.SONG
	private var _PersistentID: MPMediaEntityPersistentID = 0 // UInt64
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		_HaveBack = (_CallFrom != CALL_FROM.SONG)
		resetBtnLeft()
	}
	
	// >>> Original
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
	
	private func haveShuffle() -> Bool {
		return 1 < getCount()
	}
	// <<< Original
	
	override func getCount() -> Int {
		var count = 0
		if haveSection() {
			count = super.getCount()
		}
		else {
			count = (_ItemArr != nil) ? _ItemArr.count : 0
		}
		return count
	}
	
	override func getItem(indexPath: IndexPath) -> MPMediaItem? {
		var item: MPMediaItem! = nil
		if haveSection() {
			item = _CollectionArr[_SectionArr[indexPath.section].range.location + indexPath.row].representativeItem
		}
		else {
			item = _ItemArr[indexPath.row]
		}
		return item
	}
	
	override func haveSection() -> Bool {
		return _CallFrom == CALL_FROM.SONG
	}
	
	// セクション数
	override func numberOfSections(in tableView: UITableView) -> Int {
		let num = super.numberOfSections(in: tableView)
		if !haveShuffle() {
			return num
		}
		return num + 1
	}
	
	// セクション設定
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if !haveShuffle() {
			return super.tableView(tableView, viewForHeaderInSection: section)
		}
		if 0 < section {
			return super.tableView(tableView, viewForHeaderInSection: section-1)
		}
		return nil
	}
	
	// セクション名
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if !haveShuffle() {
			return super.tableView(tableView, titleForHeaderInSection: section)
		}
		if 0 < section {
			return super.tableView(tableView, titleForHeaderInSection: section-1)
		}
		return nil
	}
	
	// セクション単位のデータ数
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if !haveShuffle() {
			return haveSection() ? _SectionArr[section].range.length : _ItemArr.count
		}
		if 0 < section {
			return haveSection() ? _SectionArr[section-1].range.length : _ItemArr.count
		}
		return 1
	}
	
	// セルデータを返す
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if !haveShuffle() {
			return super.tableView(tableView, cellForRowAt: indexPath)
		}
		
		var cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: getNameCell(), for: indexPath)
		
		if 0 < indexPath.section {
			var varIndexPath = indexPath
			varIndexPath.section -= 1
			if let item = getItem(indexPath: varIndexPath) {
				setDataCell(cell: &cell, item: item)
			}
		}
		else {
			// Play Shuffle
			cell.imageView?.image = Define.ImageShuffleOn
			cell.textLabel?.text = "Play Shuffle"
			cell.detailTextLabel?.text = nil
		}
		
		return cell
	}
	
	// セル選択
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		if 0 < indexPath.section {
			var varIndexPath = indexPath
			varIndexPath.section -= 1
			if let item = getItem(indexPath: varIndexPath) {
				Singleton.sharedInstance.setPlayQuery(query: getMediaQuery())
				Singleton.sharedInstance.setPlayItem(item: item)
				Singleton.sharedInstance.setPlayShuffle(shuffle: false)
			}
		}
		else {
			// Play Shuffle
			Singleton.sharedInstance.setPlayQuery(query: getMediaQuery())
			Singleton.sharedInstance.setPlayItem(item: nil)
			Singleton.sharedInstance.setPlayShuffle(shuffle: true)
		}
		
		let vcPlay = PlayViewController()
		vcPlay.isReserve = true
		vcPlay.modalPresentationStyle = .overCurrentContext
		parent?.parent?.present(vcPlay, animated: false, completion: nil)
	}
	
}

extension SongTableViewController: ProtocolTableVC {
	
	func getName() -> String {
		return "Song"
	}
	
	func getMediaQuery() -> MPMediaQuery {
		var query: MPMediaQuery! = nil
		var forProperty: String! = nil
		
		switch true {
		case isFilterPlayList():
			query = MPMediaQuery.playlists()
			forProperty = MPMediaPlaylistPropertyPersistentID
		case isFilterArtist():
			query = MPMediaQuery.artists()
			forProperty = MPMediaItemPropertyArtistPersistentID
		case isFilterAlbum():
			query = MPMediaQuery.albums()
			forProperty = MPMediaItemPropertyAlbumPersistentID
		default:
			query = MPMediaQuery.songs()
		}
		
		if forProperty != nil {
			query.addFilterPredicate(MPMediaPropertyPredicate(value: getPersistentID(), forProperty: forProperty))
		}
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
		cell.textLabel?.text = item.value(forProperty: MPMediaItemPropertyTitle) as? String
		cell.detailTextLabel?.text = item.value(forProperty: MPMediaItemPropertyArtist) as? String
	}
	
	func onSelect(item: MPMediaItem) -> AbstractTableVC {
		assert(false, "Do not call onSelect")
	}
	
}
