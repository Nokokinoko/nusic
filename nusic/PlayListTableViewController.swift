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
	
	override func getItem(indexPath: IndexPath) -> MPMediaItem? {
		assert(false, "Do not call getItem")
	}
	
	override func haveSection() -> Bool {
		return false
	}
	
	// セルデータを返す
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: getNameCell(), for: indexPath)
		
		let playlist: MPMediaPlaylist = _Collection[indexPath.row] as! MPMediaPlaylist
		cell.textLabel?.text = playlist.name
		
		return cell
	}
	
	// セル選択
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		let playlist: MPMediaPlaylist = _Collection[indexPath.row] as! MPMediaPlaylist
		let vcSong = SongTableViewController()
		vcSong.callFromPlayList(persistentID: playlist.persistentID) // MPMediaPlaylistPropertyPersistentID
		goNext(vcNext: vcSong)
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
		assert(false, "Do not call setDataCell")
	}
	
	func onSelect(item: MPMediaItem) -> UIViewController {
		assert(false, "Do not call onSelect")
	}
	
}
