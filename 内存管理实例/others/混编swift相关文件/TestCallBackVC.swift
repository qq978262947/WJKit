//
//  testCallBack.swift
//  内存管理实例
//
//  Created by 汪俊 on 2018/5/11.
//  Copyright © 2018年 汪俊. All rights reserved.
//

import UIKit

class TestCallBackVC: UIViewController {

    override func viewDidLoad() {
        self.test1()
    }
    
    func test1() {
//        id __strong obj = [[NSObject alloc] init];
//        NSLog(@"retainCount-1 = %lu", _objc_rootRetainCount(obj));//1
//        let obj = NSObject()
//        print("retainCount-1 =" + NSStringFromClass(obj.classForCoder))
    }
    
    func test2() {
        // 元组
        let t1 : (String, Int) = ("李刚" ,34)
        print(t1)
        var _ : (String?, Int) = (nil ,34)
        
        // 元组还支持元素命名
        var _ : (name:String, age:Int) = (name:"李刚" ,age:34)
        // 赋值时可以省略命名  var t3 : (name:String, age:Int) = ("李刚",34)
        // 定义类型可以整个缺省，赋值时添加 var t3 = (name:"李刚",age:34)
        
        // 注意！！！如果定义的类型中没有命名，赋值的命名是无效的
        var _ : (String, Int) = (name:"李刚" ,age:34)  // 此时访问t4.name会报错
        
        // 元组支持嵌套
        var _ : (String, (String, Int)) = ("基本信息", ("李刚" ,34))
        
        // 可以将元组的类型重定义为一个类型名
        typealias namedFishesType = (first:String, second:String, third:String)
        let namedFishes: namedFishesType = ("cod", "dab", "eel")
        print(namedFishes.first)
        
        /**
        // 接下来，元组的数据访问
        // 当元素未命名时，采用自然顺序访问，序号从0开始
        // 例如
        var name = ""
        var age = 0
        
        var t2 = ("李刚",34)
        name = t2.0
        age = t2.1
        
        // 当元素命名时，可以用命名访问数据，当然仍可以使用序号进行访问
        // 例如
        var t3 = (name:"李刚",34)
        // 仍然可以用序号访问
        name = t3.0
        // 也可以用命名访问
        name = t3.name
        
        // 可以用多个变量同时进行访问
        // 例如
        let t4 = (name:"李刚",34)
        var t4_test1:(name: String, age: Int) = t4 // 即可同时获取name，age
        var t4_test2:(name: String, Int) = t4 // 不需要的参数可以缺省
        
        // 另外注意，元组为数值类型，因此元组的拷贝是值拷贝
        // 例如
        var t5 = (name:"李刚", 34)
        var t5_copy = t5
        t5.name = "王帅"
        print(t5_copy.name)  //输出为 李刚
        
        // 元组的数据修改
        // 虽然元组的数据不能增删，但是修改还是可以的
        var t6 = (name:"李刚" ,34)
        t6.name = "王帅"
        t6 = ("李教授" ,45)
        // 但是数据类型不能改变
        // t2.name = 11 //报错！！！
        
        // 如果是常量定义，元组的数据不能改变
        let t7 = (name:"李一" ,24)
        // t7.name = "李二狗"  //报错！！！
        
        // 当然，如果指定数据类型为Any，这种情况下数据可以改变类型
        var t_any : (String, Any) = ("李一" ,24)
        t_any.1 = "可以改为String"   //Any不限定数据类型
         */
    }
    
}
