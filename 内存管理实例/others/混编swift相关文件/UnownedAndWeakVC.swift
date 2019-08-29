//
//  UnownedAndWeak.swift
//  内存管理实例
//
//  Created by 汪俊 on 2018/5/11.
//  Copyright © 2018年 汪俊. All rights reserved.
//

import UIKit

class UnownedAndWeakVC: UIViewController {
    
    override func viewDidLoad() {
//        官方的解释:
//        “If the captured reference will never become nil, it should always be captured as an unowned reference, rather than a weak reference.”
//        解释：如果该引用不会变成nil,那么你应该使用unowned引用，而不是weak。所以unowned其实有点儿像Objective - C里面的unsafe_unretained。而且这里有一点需要注意:不要使用weak去修饰一个let,因为该引用之后会变，所以只能是var，这一点在官方文档里面也有提示:
//        “Weak references must be declared as variables, to indicate that their value can change at runtime. A weak reference cannot be declared as a constant.”
//        翻译：弱引用必须声明为变量，以表明它们的值在运行时可以更改。弱引用不能被声明为常量。
//        上述情况最常见的出现场景就是使用delegate的时候，我们通常会把delegate属性用weak修饰
//        举例： weak var delegate: TestDelegate
    }
    
    
}
