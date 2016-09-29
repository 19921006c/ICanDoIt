//
//  HomeModel.swift
//  ICanDoIt
//
//  Created by J on 2016/9/26.
//  Copyright © 2016年 J. All rights reserved.
//

import UIKit

let KHomeId = "KHomeId"
private let KisFirstInstallApp = "KisFirstInstallApp"
class HomeModel: NSObject, NSCoding {
    var title : String?
    var id : String?
    var isFinish : Bool?
    var content : [String]?
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(isFinish!, forKey: "isFinish")
        aCoder.encode(content, forKey: "content")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        title = aDecoder.decodeObject(forKey: "title") as? String
        id = aDecoder.decodeObject(forKey: "id") as! String?
        isFinish = aDecoder.decodeBool(forKey: "isFinish")
        content = aDecoder.decodeObject(forKey: "content") as! [String]?
    }
    
    class func dataWithCache() -> [HomeModel]{
        
        var array : [HomeModel]? = NSKeyedUnarchiver.unarchiveObject(withFile: kHomePath) as! [HomeModel]?
        if array == nil {//没有数据
            let userDefault = UserDefaults.standard
            
            let isNotFirstInstallApp = userDefault.bool(forKey: KisFirstInstallApp)
            
            if !isNotFirstInstallApp {//是第一次安装程序,拿默认数据
                let strArray = NSArray(contentsOfFile: Bundle.main.path(forResource: "data", ofType: "plist")!) as! [String]
                var tmpArray = [HomeModel]()
                for str in strArray {
                    let model = HomeModel()
                    model.title = str
                    let id = userDefault.integer(forKey: KHomeId) + 1
                    model.id = "\(id)"
                    userDefault.set(id, forKey: KHomeId)
                    model.isFinish = false
                    model.content = [String]()
                    tmpArray.append(model)
                }
                array = tmpArray
                
                userDefault.set(true, forKey: KisFirstInstallApp)
                NSKeyedArchiver.archiveRootObject(tmpArray, toFile: kHomePath)
            }else{
                array = [HomeModel]()
            }
        }
        
        return array!
    }
    override init() {
    
    }
}
