//
//  HomeDetailedCell.swift
//  ICanDoIt
//
//  Created by J on 2016/9/29.
//  Copyright © 2016年 J. All rights reserved.
//

import UIKit

private let identifier = "HomeDetailedCell"

class HomeDetailedCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    var content : String?{
        didSet{
            label.text = self.content
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    class func cellWithTableView(tableView : UITableView) -> HomeDetailedCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        
        if cell == nil {
            cell = Bundle.main.loadNibNamed(identifier, owner: self, options: nil)?.last as! UITableViewCell?
        }
        return cell! as! HomeDetailedCell
    }
    
}
