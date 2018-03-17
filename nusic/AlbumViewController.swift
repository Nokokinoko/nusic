//
//  AlbumViewController.swift
//  nusic
//
//  Created by SyotaTsuda on 2018/03/17.
//  Copyright © 2018年 Syota Tsuda. All rights reserved.
//

import UIKit

class AlbumViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var AlbumTable: UITableView!
	
	private let myiPhoneItems: NSArray = ["iOS8", "iOS7", "iOS6", "iOS5", "iOS4"]
	private let myAndroidItems: NSArray = ["5.x", "4.x", "2.x", "1.x"]
	private let mySections: NSArray = ["iPhone", "Android"]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		AlbumTable.frame = CGRect(
			x: 0,
			y: UIApplication.shared.statusBarFrame.height,
			width: self.view.frame.width,
			height: self.view.frame.height - UIApplication.shared.statusBarFrame.height
		)
		
		AlbumTable.delegate = self
		AlbumTable.dataSource = self
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// セクション名
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return mySections[section] as? String
	}
	
	// セクション数
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return mySections.count
	}
	
	// セクション単位のデータ数
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return myiPhoneItems.count
		}
		else if section == 1 {
			return myAndroidItems.count
		}
		return 0
	}
	
	// セルデータを返す
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath)
		
		if indexPath.section == 0 {
			cell.textLabel?.text = "\(myiPhoneItems[indexPath.row])"
		}
		else if indexPath.section == 1 {
			cell.textLabel?.text = "\(myAndroidItems[indexPath.row])"
		}
		
		return cell
	}
	
	// セル選択
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == 0 {
			print("Value: \(myiPhoneItems[indexPath.row])")
		}
		else if indexPath.section == 1 {
			print("Value: \(myAndroidItems[indexPath.row])")
		}
	}
	
}
