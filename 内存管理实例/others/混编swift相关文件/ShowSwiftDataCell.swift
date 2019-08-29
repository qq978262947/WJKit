//
//  ShowSwiftDataCell.swift
//  内存管理实例
//
//  Created by 汪俊 on 2018/5/11.
//  Copyright © 2018年 汪俊. All rights reserved.
//

import UIKit

class ShowSwiftDataCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.setupCurrentCell()
    }
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        self.setupCurrentCell()
//    }
    
    
    static public func cellIdentifier() -> String {
        return "ShowSwiftDataCell"
    }
    
    static public func cellWithTableView(tableView :UITableView) -> ShowSwiftDataCell {
        // 纯代码的cell
//        self.tableView.register(ShowSwiftDataCell.classForCoder(), forCellReuseIdentifier: identifer) // 不放在一起，出cell的时候会调用setvalueforkey。可能不太好
        let cell = tableView.dequeueReusableCell(withIdentifier: ShowSwiftDataCell.cellIdentifier()) as! ShowSwiftDataCell
        cell.textLabel?.textColor = UIColor(red: 67.0/255.0, green: 133.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        cell.textLabel!.font = UIFont.boldSystemFont(ofSize: 16)
        cell.backgroundColor = UIColor.clear
        
        // xib中的cell
//        let identifier = self.cellIdentifier()
//        let nib = UINib(nibName: identifier, bundle: nil)
//        tableView.register(nib, forCellReuseIdentifier: identifier)
//        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as!ShowSwiftDataCell
        
        return cell
    }
}

