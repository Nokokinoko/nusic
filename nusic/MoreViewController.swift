//
//  MoreViewController.swift
//  nusic
//
//  Created by SyotaTsuda on 2018/03/20.
//  Copyright © 2018年 Syota Tsuda. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	private let SIZE_HEIGHT_CELL: CGFloat = 60
	private let SIZE_FONT_L: CGFloat = 16
	private let SIZE_FONT_S: CGFloat = 12
	
	private var _TableView: UITableView!
	
	private enum KEY_SECTION: Int {
		case VERSION = 0
		case THANK = 1
		case MYSELF = 2
	}
	private let _Section: [String] = [
		NSLocalizedString("version", tableName: Define.NameLocalizedString, comment: ""),
		NSLocalizedString("thank", tableName: Define.NameLocalizedString, comment: ""),
		"Created by SYOTA TSUDA"
	]
	
	private enum CELL_THANK: Int {
		case DESCRIPTION = 0
		case DONATION = 1
	}
	
	private enum CELL_MYSELF: Int {
		case WEB = 0
		case APP = 1
		case COPYRIGHT = 2
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = UIColor.white
		
		self.navigationItem.title = "nusic"
		
		self.navigationItem.leftBarButtonItem = nil
		
		let btnRight = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MoreViewController.goClose))
		self.navigationItem.rightBarButtonItem = btnRight
		
		_TableView = UITableView()
		_TableView?.frame = self.view.frame
		_TableView?.delegate = self
		_TableView?.dataSource = self
		_TableView?.rowHeight = UITableViewAutomaticDimension
		_TableView?.estimatedRowHeight = SIZE_HEIGHT_CELL
		self.view.addSubview(_TableView)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	@objc func goClose() {
		self.dismiss(animated: true)
	}
	
	// セクション数
	func numberOfSections(in tableView: UITableView) -> Int {
		return _Section.count
	}
	
	// セクション設定
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let label: LabelSection = LabelSection()
		label.text = _Section[section]
		return label
	}
	
	// セクション名
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return _Section[section]
	}

	// セクション単位のデータ数
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		var count: Int = 0
		switch section {
		case KEY_SECTION.VERSION.rawValue:	count = 1
		case KEY_SECTION.THANK.rawValue:	count = 2
		case KEY_SECTION.MYSELF.rawValue:	count = 3
		default: break
		}
		return count
	}
	
	// セルデータを返す
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
		
		switch indexPath.section {
		case KEY_SECTION.VERSION.rawValue:
			cell.textLabel?.textAlignment = .right
			cell.textLabel?.text = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
			cell.textLabel?.textColor = Define.ColorBlack
			cell.textLabel?.font = UIFont.systemFont(ofSize: SIZE_FONT_L)
			cell.selectionStyle = UITableViewCellSelectionStyle.none
		case KEY_SECTION.THANK.rawValue:
			switch indexPath.row {
			case CELL_THANK.DESCRIPTION.rawValue:
				cell.textLabel?.numberOfLines = 0
				cell.textLabel?.lineBreakMode = NSLineBreakMode.byCharWrapping
				cell.textLabel?.text = NSLocalizedString("description", tableName: Define.NameLocalizedString, comment: "")
				cell.textLabel?.textColor = Define.ColorBlack
				cell.textLabel?.font = UIFont.systemFont(ofSize: SIZE_FONT_S)
				cell.selectionStyle = UITableViewCellSelectionStyle.none
			case CELL_THANK.DONATION.rawValue:
				cell.indentationLevel = 1
				cell.textLabel?.text = NSLocalizedString("donation", tableName: Define.NameLocalizedString, comment: "")
				cell.textLabel?.textColor = Define.ColorBlack
				cell.textLabel?.font = UIFont.systemFont(ofSize: SIZE_FONT_L)
				cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
			default: break
			}
		case KEY_SECTION.MYSELF.rawValue:
			switch indexPath.row {
			case CELL_MYSELF.WEB.rawValue:
				cell.indentationLevel = 1
				cell.textLabel?.text = NSLocalizedString("web", tableName: Define.NameLocalizedString, comment: "")
				cell.textLabel?.textColor = Define.ColorBlack
				cell.textLabel?.font = UIFont.systemFont(ofSize: SIZE_FONT_L)
				cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
			case CELL_MYSELF.APP.rawValue:
				cell.indentationLevel = 1
				cell.textLabel?.text = NSLocalizedString("app", tableName: Define.NameLocalizedString, comment: "")
				cell.textLabel?.textColor = Define.ColorBlack
				cell.textLabel?.font = UIFont.systemFont(ofSize: SIZE_FONT_L)
				cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
			case CELL_MYSELF.COPYRIGHT.rawValue:
				cell.textLabel?.numberOfLines = 0
				cell.textLabel?.textAlignment = .right
				cell.textLabel?.text = "Copyright (c) 2018 SYOTA TSUDA\nReleased under the MIT license"
				cell.textLabel?.textColor = Define.ColorBlack
				cell.textLabel?.font = UIFont.systemFont(ofSize: SIZE_FONT_S)
				cell.selectionStyle = UITableViewCellSelectionStyle.none
			default: break
			}
		default: break
		}
		
		return cell
	}
	
	// セル選択
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		switch indexPath.section {
		case KEY_SECTION.THANK.rawValue:
			switch indexPath.row {
			case CELL_THANK.DONATION.rawValue:
				let url = URL(string: "http://amzn.asia/2UMEnZ3")
				if UIApplication.shared.canOpenURL(url!) {
					UIApplication.shared.open(url!)
				}
			default: break
			}
		case KEY_SECTION.MYSELF.rawValue:
			switch indexPath.row {
			case CELL_MYSELF.WEB.rawValue:
				let url = URL(string: "http://dokonoko.pinoko.jp/project/")
				if UIApplication.shared.canOpenURL(url!) {
					UIApplication.shared.open(url!)
				}
			case CELL_MYSELF.APP.rawValue:
				let url = URL(string: "itms-apps://itunes.apple.com/us/artist/soilworks/id967143105")
				UIApplication.shared.open(url!)
			default: break
			}
		default: break
		}
	}
	
}
