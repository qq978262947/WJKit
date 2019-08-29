//
//  showSwiftDataVC.swift
//  内存管理实例
//
//  Created by 汪俊 on 2018/5/11.
//  Copyright © 2018年 汪俊. All rights reserved.
//

import UIKit
//import SnapKit // 用法和masonry基本一致


//@objc 作用
//1 fileprivate 或者 private  保证方法私有 能在同一个类 或者 同一个文件（extension）中访问这个方法 如果定义为private  那么只能在一个类中访问 不能在类扩展中访问
//2 允许这个函数在“运行时”通过oc的消息机制调用
@objc class ShowSwiftDataVC: UIViewController { // 只是需要测试不用对外暴露出来
    
    var isFirstPage: Bool = true
    /**
     * 懒加载
     */
    lazy var tableView: UITableView = {
        () -> UITableView in
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height), style: UITableViewStyle.plain)
        self.view.addSubview(tableView)
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        tableView.delegate = self // 确保百分百转换成功用as!  - 这里无所谓
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
//        tableView.backgroundColor = UIColor.orange
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        return tableView
    }()
    
    lazy var configurationModelArray: NSArray = {
        () -> NSArray in
        if (self.isFirstPage) {
            self.configurationModelArray = [
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any]),
                DemoConfigurationModel(demoItemTitleName: "swift环境下", demoItemNextPageArray: self.memoryDataArray() as! [Any])
            ]
        }
        return self.configurationModelArray
    }()
    
    func memoryDataArray() ->NSArray {
        return [
            DemoConfigurationModel(demoItemTitleName: "总览", demoItemClassName:"ShowAllVC" ),
            DemoConfigurationModel(demoItemTitleName: "unowned和weak", demoItemClassName:"ShowSwiftDataVC" ),
            DemoConfigurationModel(demoItemTitleName: "界面", demoItemClassName:"InteractionVC" ),
            DemoConfigurationModel(demoItemTitleName: "闭包", demoItemClassName:"ClosureVC" ),
            DemoConfigurationModel(demoItemTitleName: "EditNameOrNicknameVC", demoItemClassName:"EditNameOrNicknameVC" )
        ]

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1. 初始化当前view
        self.initView();
        // 2.
    }
    
    func initView() {
        self.view.backgroundColor = UIColor.white
        let identifer = ShowSwiftDataCell.cellIdentifier()
        // 如果是xib的cell用这个
//        let nib = UINib(nibName: identifer, bundle: nil)
//        self.tableView.register(nib, forCellReuseIdentifier: identifer)
        self.tableView.register(ShowSwiftDataCell.classForCoder(), forCellReuseIdentifier: identifer)
    }
}

extension ShowSwiftDataVC {
    public func goNextPage(dataArray: NSArray, title: String) {
        let datatVC = ShowSwiftDataVC()
        datatVC.title = title
        datatVC.configurationModelArray = dataArray
        datatVC.isFirstPage = false
        self.navigationController?.pushViewController(datatVC, animated: true)
    }
}

extension ShowSwiftDataVC: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let demoConfigurationModel = self.configurationModelArray[indexPath.row] as! DemoConfigurationModel
        if ((demoConfigurationModel.demoItemNextPageArray != nil) && demoConfigurationModel.demoItemNextPageArray.count > 0) {
            self.goNextPage(dataArray: demoConfigurationModel.demoItemNextPageArray! as NSArray, title: demoConfigurationModel.demoItemTitleName)
        } else if ((demoConfigurationModel.demoItemMethodNameBlock) != nil) {
            demoConfigurationModel.demoItemMethodNameBlock(demoConfigurationModel.demoItemTitleName)
        } else {
            if (demoConfigurationModel.demoItemClassName != nil && !demoConfigurationModel.demoItemClassName.elementsEqual("")) {
                let projectName = Bundle.main.infoDictionary!["CFBundleExecutable"]! as! String
                let demoVCClazz = NSClassFromString(projectName + "." + demoConfigurationModel.demoItemClassName) as! UIViewController.Type
                let demoVC = demoVCClazz.init()
                demoVC.view.backgroundColor = UIColor.white
                demoVC.title = demoConfigurationModel.demoItemTitleName
                self.navigationController?.pushViewController(demoVC, animated: true)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension ShowSwiftDataVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.configurationModelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let configurationModel = self.configurationModelArray[indexPath.row] as! DemoConfigurationModel
        let cell = ShowSwiftDataCell.cellWithTableView(tableView: tableView)
        cell.textLabel?.text = configurationModel.demoItemTitleName
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
