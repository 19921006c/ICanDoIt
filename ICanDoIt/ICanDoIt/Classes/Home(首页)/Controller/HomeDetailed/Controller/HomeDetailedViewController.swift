//
//  HomeDetailedViewController.swift
//  ICanDoIt
//
//  Created by J on 2016/9/28.
//  Copyright © 2016年 J. All rights reserved.
//

import UIKit

class HomeDetailedViewController: UIViewController {

    var allArray : [HomeModel]?
    var model : HomeModel?{
        didSet{
            title = model?.title
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        setView()
        setNavigationBar()
        setTableView()
    }
    
    func setView() {
        view.backgroundColor = UIColor(patternImage: UIImage(named: "home_bg")!)
        view.addSubview(addBtn)
    }
    
    func setTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.backgroundColor = UIColor(patternImage: UIImage(named: "home_bg")!)
    }
    
    func setNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.trash, target: self, action: #selector(rightDown))
    }
    
    func rightDown() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: KNotificationForHomeRefreshWithDelete), object: nil, userInfo: ["model" : model])
        navigationController!.popViewController(animated: true)
    }
    
    private lazy var tableView : UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 64 + 60, width: self.view.bounds.width, height: self.view.bounds.height - 64 - 60))
        return tableView
    }()
    
    private lazy var addBtn : UIButton = {
        let addBtn = UIButton(type: UIButtonType.custom)
        addBtn.frame = CGRect(x: 10, y: 64 + 10, width: self.view.bounds.width - 20, height: 40)
        addBtn.setImage(UIImage(named: "CreatTopicPlus"), for: UIControlState.normal)
        addBtn.setImage(UIImage(named: "CreatTopicPlus"), for: UIControlState.highlighted)
        addBtn.setBackgroundImage(UIImage(named: "CreatTopicCategory"), for: UIControlState.normal)
        addBtn.setBackgroundImage(UIImage(named: "CreatTopicCategory"), for: UIControlState.highlighted)
        addBtn.setTitle("添加一条数据", for: UIControlState.normal)
        addBtn.setTitle("添加一条数据", for: UIControlState.highlighted)
        addBtn.setTitleColor(UIColor.gray, for: UIControlState.normal)
        addBtn.setTitleColor(UIColor.gray, for: UIControlState.highlighted)
        addBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        addBtn.addTarget(self, action: #selector(addBtnAction), for: UIControlEvents.touchUpInside)
        return addBtn
    }()
    func addBtnAction() {
        let alertController = UIAlertController(title: "添加一条数据", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
        let enterAction = UIAlertAction(title: "添加", style: UIAlertActionStyle.default) { (UIAlertAction) in
            self.model?.content?.append((alertController.textFields?.first?.text)!)
            self.tableView.reloadData()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: KNotificationForHomeRefresh), object: nil)
        }
        alertController.addTextField { (textFiled) in
            textFiled.placeholder = "请输入内容"
        }
        alertController.addAction(cancelAction)
        alertController.addAction(enterAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension HomeDetailedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.content?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = HomeDetailedCell.cellWithTableView(tableView: tableView)
        cell.content = model?.content?[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            model?.content?.remove(at: indexPath.row)
            tableView.reloadData()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: KNotificationForHomeRefresh), object: nil)
        }
    }
}
