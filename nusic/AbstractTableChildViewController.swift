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
		
		self.navigationItem.title = getTitle()
		
		_BtnLeft = UIBarButtonItem(title: "< Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AbstractTableViewController.goBack))
		self.navigationItem.leftBarButtonItem = nil
		
		let btnRight = UIBarButtonItem(title: "More", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AbstractTableViewController.goMore))
		self.navigationItem.rightBarButtonItem = btnRight
		
		if haveItem() {
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
		else {
			let label = UILabel()
			label.text = getStringNothing()
			label.font = UIFont.boldSystemFont(ofSize: 30)
			label.sizeToFit()
			label.center = self.view.center
			self.view.addSubview(label)
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	// >>> Abstract
	func getTitle() -> String {
		return ""
	}
	
	func haveItem() -> Bool {
		return false
	}
	
	func getStringNothing() -> String {
		return ""
	}
	
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
	
	func onSelect(indexPath: IndexPath) -> UIViewController? {
		return nil
	}
	// <<< Abstract
	
	func resetBtnLeft() {
		self.navigationItem.leftBarButtonItem = _Back ? _BtnLeft : nil
	}
	
	@objc func goBack() {
		self.navigationController?.popViewController(animated: true)
	}
	
	func goNext(vcNext: UIViewController) {
		self.navigationController?.pushViewController(vcNext, animated: true)
	}
	
	@objc func goMore() {
		let vcNext = UINavigationController(rootViewController: MoreViewController())
		vcNext.modalTransitionStyle = .crossDissolve
		self.present(vcNext, animated: true, completion: nil)
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
		
		let vcNext = onSelect(indexPath: indexPath)
		if vcNext is AbstractTableViewController {
			goNext(vcNext: vcNext!)
		}
		else if vcNext != nil {
			// UIViewController
			vcNext!.modalTransitionStyle = .coverVertical
			self.present(vcNext!, animated: true, completion: nil)
		}
	}
	
}
