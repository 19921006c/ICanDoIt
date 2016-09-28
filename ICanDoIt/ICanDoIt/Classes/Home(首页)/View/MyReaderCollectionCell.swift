//
//  MyReaderCollectionCell.swift
//  ICanDoIt
//
//  Created by J on 2016/9/26.
//  Copyright © 2016年 J. All rights reserved.
//

import UIKit

class MyReaderCollectionCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor.black.cgColor
    }

}
