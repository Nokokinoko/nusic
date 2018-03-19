//
//  AbstractTableChildViewController.swift
//  nusic
//
//  Created by SyotaTsuda on 2018/03/19.
//  Copyright © 2018年 Syota Tsuda. All rights reserved.
//

import UIKit

class AbstractTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	internal var _Back: Bool = false
	private var _BtnLeft: UIBarButtonItem!
	internal var _TableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationItem.title = "nusic"
		
		_BtnLeft = UIBarButtonItem(title: "< Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AbstractTableViewController.goBack))
		self.navigationItem.leftBarButtonItem = nil
		
		let btnRight = UIBarButtonItem(title: "More", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AbstractTableViewController.goMore))
		self.navigationItem.rightBarButtonItem = btnRight
		
		_TableView = UITableView()
		_TableView?.frame = CGRect(
			x: 0,
			y: 0,
			width: self.view.frame.width,
			height: self.view.frame.height
		)
		_TableView?.register(UINib(nibName: getNameNib(), bundle: nil), forCellReuseIdentifier: getIdentifierCell())
		_TableView?.delegate = self
		_TableView?.dataSource = self
		self.view.addSubview(_TableView)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	// >>> Abstract
	func getNameNib() -> String {
		return ""
	}
	
	func getIdentifierCell() -> String {
		return ""
	}
	
	func getCountSection() -> Int {
		return 0
	}
	
	func getNameSection(section: Int) -> String {
		return ""
	}
	
	func getCountCellBySection(section: Int) -> Int {
		return 0
	}
	
	func setDataCell(cell: inout UITableViewCell, indexPath: IndexPath) {}
	
	func onSelect(indexPath: IndexPath) {}
	// <<< Abstract
	
	func setBtnLeft() {
		self.navigationItem.leftBarButtonItem = _Back ? _BtnLeft : nil
	}
	
	@objc func goBack() {
		self.navigationController?.popViewController(animated: true)
	}
	
	func goMore() {
	}
	
	// セクション数
	func numberOfSections(in tableView: UITableView) -> Int {
		return getCountSection()
	}
	
	// セクション名
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return getNameSection(section: section)
	}
	
	// セクション単位のデータ数
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return getCountCellBySection(section: section)
	}
	
	// セルデータを返す
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: getIdentifierCell(), for: indexPath)
		setDataCell(cell: &cell, indexPath: indexPath)
		return cell
	}
	
	// セル選択
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		onSelect(indexPath: indexPath)
	}
	
}
