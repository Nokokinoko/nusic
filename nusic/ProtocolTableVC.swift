//
//  ProtocolTableVC.swift
//  nusic
//
//  Created by SyotaTsuda on 2018/03/28.
//  Copyright © 2018年 Syota Tsuda. All rights reserved.
//

import MediaPlayer

protocol ProtocolTableVC: class {
	
	func getName() -> String
	
	func getMediaQuery() -> MPMediaQuery
	
	func setDataCell(cell: inout UITableViewCell, item: MPMediaItem)
	
	func onSelect(item: MPMediaItem) -> AbstractTableVC
	
}
