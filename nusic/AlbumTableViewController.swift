//
//  AlbumTableViewController.swift
//  nusic
//
//  Created by SyotaTsuda on 2018/03/17.
//  Copyright © 2018年 Syota Tsuda. All rights reserved.
//

import UIKit

class AlbumTableViewController: AbstractTableViewController {
	
	private let myiPhoneItems: NSArray = ["iOS8", "iOS7", "iOS6", "iOS5", "iOS4"]
	private let myAndroidItems: NSArray = ["5.x", "4.x", "2.x", "1.x"]
	private let mySections: NSArray = ["iPhone", "Android"]
	
	override func getNameNib() -> String {
		return "AlbumTableViewCell"
	}
	
	override func getIdentifierCell() -> String {
		return "AlbumTableViewCell"
	}
	
	override func getCountSection() -> Int {
		return mySections.count
	}
	
	override func getNameSection(section: Int) -> String {
		return mySections[section] as! String
	}
	
	override func getCountCellBySection(section: Int) -> Int {
		if section == 0 {
			return myiPhoneItems.count
		}
		else if section == 1 {
			return myAndroidItems.count
		}
		return 0
	}
	
	override func setDataCell(cell: inout UITableViewCell, indexPath: IndexPath) {
		if indexPath.section == 0 {
			cell.textLabel?.text = "\(myiPhoneItems[indexPath.row])"
		}
		else if indexPath.section == 1 {
			cell.textLabel?.text = "\(myAndroidItems[indexPath.row])"
		}
	}
	
	override func onSelect(indexPath: IndexPath) {
	}
	
}
