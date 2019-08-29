//
//  Person.m
//  内存管理实例
//
//  Created by 汪俊 on 2018/4/28.
//  Copyright © 2018年 汪俊. All rights reserved.
//

#import "Person.h"

@implementation Person
//当前setter方法有问题
//当创建多个Animal对象时,这段代码只能保证接收最新的对象,对旧对象不释放,造成内存泄漏
//- (void) setItem:(Animal *)item
//{
//    if(_item != item)
//    {
//        //让item的引用计数加1
//        [item retain];
//        _item = item;
//    }
//}

//这个setter方法更加安全
- (void)setItem:(Animal *)item {
    if(_item != item) { // 这里是防止是同一个对象
        //将_item引用的实例变量的引用计数减1,先释放旧对象
        [_item release];
        //让item的引用计数加1,并赋给_item实例变量,持有新对象
        _item = [item retain];
    }
}

//备注:如果不加if条件判断语句,就要写成如下形式:
//[item retain]  ---先保留对象,防止是同一个对象被释放
//[_item release]
//_item = item

- (Animal *)item {
    return _item;
}

- (void)dealloc {
    [_item release];
    NSLog(@"Person调用dealloc,引用计数为0");
    [super dealloc]; // ARC环境下编译器识别到}会自动添加上[super dealloc];这一句
}

@end
