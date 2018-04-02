//
//  AbstractTableVC.swift
//  nusic
//
//  Created by SyotaTsuda on 2018/03/28.
//  Copyright © 2018年 Syota Tsuda. All rights reserved.
//

import UIKit
import MediaPlayer

class AbstractTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	private var _Protocol: ProtocolTableVC!
	
	internal var _HaveBack: Bool = false
	private var _BtnLeft: UIBarButtonItem!
	internal var _TableView: UITableView!
	
	internal var _Collection: [MPMediaItemCollection]!
	private var _CollectionSection: [MPMediaQuerySection]!
	
	private let SUFFIX_CELL = "TableViewCell"
	
	convenience init() {
		self.init(nibName: nil, bundle: nil)
	}
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	func setup() {
		assert(type(of: self) != AbstractTableVC.self, "Do not instantiate AbstractTableVC")
		assert(self is ProtocolTableVC, "Please implement ProtocolTableVC")
		
		_Protocol = self as! ProtocolTableVC
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let query = _Protocol.getMediaQuery()
		_Collection = query.collections
		_CollectionSection = query.collectionSections
		
		let count = (_Collection != nil) ? _Collection.count : 0
		self.navigationItem.title = _Protocol.getName() + " / " + count.description + " Hit"
		
		_BtnLeft = UIBarButtonItem(title: "< Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AbstractTableVC.goBack))
		self.navigationItem.leftBarButtonItem = nil
		
		let btnRight = UIBarButtonItem(title: "More", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AbstractTableVC.goMore))
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
			label.text = "I have not " + _Protocol.getName() + " :("
			label.font = UIFont.boldSystemFont(ofSize: 30)
			label.sizeToFit()
			label.textColor = Define.ColorBlack
			label.center = self.view.center
			self.view.addSubview(label)
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	func getNameCell() -> String {
		return _Protocol.getName() + SUFFIX_CELL
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
	
	func getItem(indexPath: IndexPath) -> MPMediaItem? {
		var key = haveSection() ? _CollectionSection[indexPath.section].range.location : 0
		key += indexPath.row
		return _Collection[key].representativeItem
	}
	
	func haveSection() -> Bool {
		return true
	}
	
	// セクション数
	func numberOfSections(in tableView: UITableView) -> Int {
		return haveSection() ? _CollectionSection.count : 1
	}
	
	// セクション設定
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let label: LabelSection = LabelSection()
		label.text = haveSection() ? _CollectionSection[section].title : nil
		return label
	}
	
	// セクション名
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return haveSection() ? _CollectionSection[section].title : nil
	}
	
	// セクション単位のデータ数
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return haveSection() ? _CollectionSection[section].range.length : _Collection.count
	}
	
	// セルデータを返す
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: getNameCell(), for: indexPath)
		
		if let item = getItem(indexPath: indexPath) {
			_Protocol.setDataCell(cell: &cell, item: item)
		}
		
		return cell
	}
	
	// セル選択
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		if let item = getItem(indexPath: indexPath) {
			let vcNext = _Protocol.onSelect(item: item)
			if vcNext is AbstractTableVC {
				goNext(vcNext: vcNext)
			}
			else if let vcPlay = vcNext as? PlayViewController {
				Singleton.sharedInstance.setPlayQuery(query: _Protocol.getMediaQuery())
				Singleton.sharedInstance.setPlayItem(item: item)
				vcPlay.isReserve = true
				
				vcPlay.modalPresentationStyle = .overCurrentContext
				parent?.parent?.present(vcPlay, animated: false, completion: nil)
			}
		}
	}
	
}
