//
//  HomeViewController.swift
//  ICanDoIt
//
//  Created by J on 16/9/23.
//  Copyright © 2016年 J. All rights reserved.
//

import UIKit

//复用cell identifier
private let MyReaderCollectionCellIdentifier = "MyReaderCollectionCell"
private let MyReaderHeaderCollectionReusableViewIdentifier = "MyReaderHeaderCollectionReusableView"
private let MyReaderFooterCollectionReusableViewIdentifier = "MyReaderFooterCollectionReusableView"

//获取缓存目录
let kPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
//plist 文件路径
let kHomePath = kPath + "HomeModelArray.data"
//首页刷新通知
let KNotificationForHomeRefresh = "KNotificationForHomeRefresh"
//删除数据通知
let KNotificationForHomeRefreshWithDelete = "KNotificationForHomeRefreshWithDelete"
class HomeViewController: UIViewController {
    //所有的数据模型
    var allArray = [HomeModel]()
    //完成的数据模型
    var finishArray = [HomeModel]()
    //未完成的数据模型
    var unfinishArray = [HomeModel]()
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "首页"
        //设置collection view
        setCollectionView()
        //设置navigation bar 
        setNavigationBar()
        //处理数据
        dataProcess()
        //接受通知
        notificationAddObserver()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "Constellation_bg")!)
    }
    
    //接受通知抽取方法
    func notificationAddObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshHome(notification:)), name: NSNotification.Name(rawValue: KNotificationForHomeRefreshWithDelete), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveData), name: NSNotification.Name(rawValue: KNotificationForHomeRefresh), object: nil)
    }
    //刷新首页数据
    func refreshHome(notification : Notification) {
        var index = 0
        let model = notification.userInfo?["model"] as! HomeModel
        for tmpModel in allArray {
            if tmpModel.id == model.id {
                break
            }
            index += 1
        }
        allArray.remove(at: index)
        saveData()
        //数据处理抽取方法
        dataProcessDistill()
        //
        collectionView.reloadData()
    }
    
    //数据处理
    private func dataProcess() {
        
        allArray = HomeModel.dataWithCache()
        //数据处理抽取方法
        dataProcessDistill()
    }
    //数据处理抽取方法
    private func dataProcessDistill() {
        finishArray.removeAll()
        unfinishArray.removeAll()
        for model in allArray {
            if model.isFinish! {//已完成
                finishArray.append(model)
            }else{//未完成
                unfinishArray.append(model)
            }
        }
    }
    //设置collection view
    private func setCollectionView() {
        //添加collection view
        view.addSubview(collectionView)
        //设置数据源代理
        collectionView.delegate = self
        collectionView.dataSource = self
        //注册cell
        collectionView.register(UINib(nibName: MyReaderCollectionCellIdentifier, bundle: nil), forCellWithReuseIdentifier: MyReaderCollectionCellIdentifier)
        collectionView.register(UINib(nibName: MyReaderHeaderCollectionReusableViewIdentifier, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: MyReaderHeaderCollectionReusableViewIdentifier)
        collectionView.register(UINib(nibName: MyReaderFooterCollectionReusableViewIdentifier, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: MyReaderFooterCollectionReusableViewIdentifier)
        //创建长按手势
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized(sender:)))
        //添加长按手势
        collectionView.addGestureRecognizer(longPress)
    }
    
    //MARK : 懒加载
    private lazy var collectionView: HomeCollectionView = {
        let collection = HomeCollectionView(frame: self.view.bounds, collectionViewLayout: HomeCollectionViewFlowLayout())
        
        return collection
    }()
    //MARK : 存数据
    func saveData(){
        NSKeyedArchiver.archiveRootObject(allArray, toFile: kHomePath)
    }
    
    func longPressGestureRecognized(sender: UILongPressGestureRecognizer){
        
        let state = sender.state
        let location = sender.location(in: collectionView)
        let indexPath = collectionView .indexPathForItem(at: location)
        let model : HomeModel
        if indexPath?.section == 0 {
            model = unfinishArray[(indexPath?.row)!]
        }else{
            model = finishArray[(indexPath?.row)!]
        }
        if state == UIGestureRecognizerState.began {
            let vc = HomeDetailedViewController()
            vc.model = model
            vc.allArray = allArray
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func setNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.trash, target: self, action: #selector(rightDown))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(leftDown))
    }
    func leftDown() {
        let alertController = UIAlertController(title: "添加一条数据", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField { (textFiled) in
            textFiled.placeholder = "请输入内容"
        }
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
        let enterAction = UIAlertAction(title: "添加", style: UIAlertActionStyle.default) { (_) in
            let content = alertController.textFields?.first?.text!
            let model = HomeModel()
            model.title = content
            model.id = "\(UserDefaults.standard.integer(forKey: KHomeId) + 1)"
            model.isFinish = false
            model.content = [String]()
            self.allArray.append(model)
            self.unfinishArray.append(model)
            self.collectionView.reloadData()
            self.saveData()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(enterAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func rightDown(){
        
        let alertController = UIAlertController(title: "删除数据", message: "你确定要删除数据吗？不可恢复!", preferredStyle: UIAlertControllerStyle.actionSheet)
        let cancleAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
        let enterAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.destructive) { (UIAlertAction) in
            if(FileManager.default.fileExists(atPath: kHomePath)){//可以删除
                // 删除
                try! FileManager.default.removeItem(atPath: kHomePath)
                self.allArray.removeAll()
                self.finishArray.removeAll()
                self.unfinishArray.removeAll()
                self.collectionView.reloadData()
            }
            
        }
        alertController.addAction(cancleAction)
        alertController.addAction(enterAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    deinit {
        //移除通知
        NotificationCenter.default.removeObserver(self)
    }
}

//collection view delegate & data source
extension HomeViewController:  UICollectionViewDataSource, UICollectionViewDelegate{
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyReaderCollectionCellIdentifier, for: indexPath) as! MyReaderCollectionCell
        let model : HomeModel
        
        if indexPath.section == 0 {
            model = unfinishArray[indexPath.row]
        } else {
            model = finishArray[indexPath.row]
        }
        cell.label.text = model.title
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {//未完成
            return unfinishArray.count
        }else{//已完成
            return finishArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MyReaderHeaderCollectionReusableViewIdentifier, for: indexPath) as! MyReaderHeaderCollectionReusableView
            header.index = indexPath.section
            header.backgroundColor = UIColor.white
            return header
        }
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MyReaderFooterCollectionReusableViewIdentifier, for: indexPath)
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        let section = indexPath.section
        let model : HomeModel
        let fromIndexPath = IndexPath(item: row, section: section)
        let toIndexPath : IndexPath
        if indexPath.section == 0 {
            model = unfinishArray[row]
            model.isFinish = true
            finishArray.insert(model, at: 0)
            unfinishArray.remove(at: row)
            
            toIndexPath = IndexPath(item: 0, section: 1)
        }else {
            model = finishArray[row]
            model.isFinish = false
            
            unfinishArray.append(model)
            finishArray.remove(at: row)
            
            toIndexPath = IndexPath(item: unfinishArray.count - 1, section: 0)
        }
        collectionView.moveItem(at: fromIndexPath, to: toIndexPath)
        collectionView.reloadItems(at: [toIndexPath])
        
        saveData()
    }
}
