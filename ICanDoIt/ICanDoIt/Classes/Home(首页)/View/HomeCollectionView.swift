//
//  HomeCollectionView.swift
//  ICanDoIt
//
//  Created by J on 16/9/23.
//  Copyright © 2016年 J. All rights reserved.
//

import UIKit

class HomeCollectionView: UICollectionView {

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        //设置collection view
        setCollectionView()
    }
    
    private func setCollectionView() {
        //设置背景色
        backgroundColor = UIColor.white
        
        let categoryFlowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let width = (kScreenWidth - 40) / 3
        let height : CGFloat = 33.0
        
        categoryFlowLayout.itemSize = CGSize(width: width, height: height)
        categoryFlowLayout.minimumLineSpacing = 10
        categoryFlowLayout.minimumInteritemSpacing = 0
        categoryFlowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        categoryFlowLayout.headerReferenceSize = CGSize(width: kScreenWidth, height: 54)
        categoryFlowLayout.footerReferenceSize = CGSize(width: kScreenWidth, height: 18)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: Selector(("longPressGestureRecognized:")))
        addGestureRecognizer(longPress)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
