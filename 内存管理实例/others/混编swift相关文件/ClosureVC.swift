//
//  ClosureVC.swift
//  内存管理实例
//
//  Created by 汪俊 on 2018/5/11.
//  Copyright © 2018年 汪俊. All rights reserved.
//

import UIKit

class ClosureVC: UIViewController {
    // 基本拷贝官方的示例代码 - 我只是此处放到UIViewController里了
    let name: String
    let text: String?
    
//    lazy var asHTML: () -> String = {
//        if let text = self.text {
//            return "<\(self.name)>\(text)</\(self.name)>"
//        } else {
//            return "<\(self.name) />"
//        }
//    }
    
    lazy var asHTML: () -> String = {
        [weak self] in
        if let strongSelf = self { // 这个一定要加
            if let text = self!.text {
                return "<\(self!.name)>\(text)</\(self!.name)>"
            } else {
                return "<\(self!.name) />"
            }
        }
        return "<\("123") />"
    }
    
    required init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(name) is being deinitialized")
    }
    
//    上面代码的持有关系很明显，ClosureVC持有asHTML属性，而在后面的闭包中有使用了self关键字，那么asHTML又反向持有ClosureVC，这样就形成了循环引用，同样的可以使用weak来打破这个循环引用：
    override func viewDidLoad() {
//        在Swift中的闭包(closure)和Objective - C中的block一样，会引起循环引用，从而导致内存泄露。
//        原因是凡是被闭包或者block所引用，那么闭包和block会自动持有它。这是一个比较隐蔽的陷阱，很多新手会犯这样的错误而不自知。看一段官方的示例代码：
    }
    
    
}

