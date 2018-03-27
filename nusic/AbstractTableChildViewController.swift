//
//  AbstractTableChildViewController.swift
//  nusic
//
//  Created by SyotaTsuda on 2018/03/19.
//  Copyright © 2018年 Syota Tsuda. All rights reserved.
//

import UIKit
import MediaPlayer

class AbstractTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	internal var _HaveBack: Bool = false
	private var _BtnLeft: UIBarButtonItem!
	internal var _TableView: UITableView!
	
	private var _Collection: [MPMediaItemCollection]!
	private var _CollectionSection: [MPMediaQuerySection]!
	
	private let SUFFIX_CELL = "TableViewCell"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let query = getMediaQuery()
		_Collection = query?.collections
		_CollectionSection = query?.collectionSections
		
		let count = (_Collection != nil) ? _Collection.count : 0
		self.navigationItem.title = getName() + " / " + count.description + " Hit"
		
		_BtnLeft = UIBarButtonItem(title: "< Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AbstractTableViewController.goBack))
		self.navigationItem.leftBarButtonItem = nil
		
		let btnRight = UIBarButtonItem(title: "More", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AbstractTableViewController.goMore))
		self.navigationItem.rightBarButtonItem = btnRight
		
		if 0 < count {
			_TableView = UITableView()
			_TableView?.frame = self.view.frame
			_TableView?.register(UINib(nibName: getNameCell(), bundle: nil), forCellReuseIdentifier: getNameCell())
			_TableView?.delegate = self
			_TableView?.dataSource = self
			self.view.addSubview(_TableView)
		}
		else {
			let label = UILabel()
			label.text = "I have not " + getName() + " :("
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
	func getName() -> String {
		return ""
	}
	
	func getMediaQuery() -> MPMediaQuery? {
		return nil
	}
	
	func setDataCell(cell: inout UITableViewCell, item: MPMediaItem) {}
	
	func onSelect(indexPath: IndexPath) -> UIViewController? {
		return nil
	}
	// <<< Abstract
	
	func getNameCell() -> String {
		return getName() + SUFFIX_CELL
	}
	
	func resetBtnLeft() {
		self.navigationItem.leftBarButtonItem = _HaveBack ? _BtnLeft : nil
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
		return _CollectionSection.count
	}
	
	// セクション名
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return _CollectionSection[section].title
	}
	
	// セクション単位のデータ数
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return _CollectionSection[section].range.length
	}
	
	// セルデータを返す
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: getNameCell(), for: indexPath)
		
		let key = _CollectionSection[indexPath.section].range.location + indexPath.row
		setDataCell(cell: &cell, item: _Collection[key].representativeItem!)
		
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
			vcNext!.modalPresentationStyle = .overCurrentContext
			parent?.parent?.present(vcNext!, animated: false, completion: nil)
		}
	}
	
}
