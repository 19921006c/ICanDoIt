//
//  MyReaderHeaderCollectionReusableView.swift
//  ICanDoIt
//
//  Created by J on 2016/9/26.
//  Copyright © 2016年 J. All rights reserved.
//

import UIKit

class MyReaderHeaderCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var label: UILabel!
    
    var index : Int?{
        didSet{
            if index == 0 {
                label.text = "未完成:   (长按进入详情)"
            }else{
                label.text = "已完成:   (长按进入详情)"
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
