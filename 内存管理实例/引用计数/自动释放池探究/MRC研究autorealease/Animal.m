//
//  Animal.m
//  内存管理实例
//
//  Created by 汪俊 on 2018/4/28.
//  Copyright © 2018年 汪俊. All rights reserved.
//

#import "Animal.h"

@implementation Animal

- (id)init {
    if(self == [super init]) {
        NSLog(@"init方法中,引用计数为:%ld" , self.retainCount);
    }
    return self;
}

+ (Animal *)productItem {
    Animal *item = [Animal new]; // 引用计数为1
    NSLog(@"函数返回之前的引用计数：%ld" , item.retainCount);
    // autorelease不会改变对象的引用计数
    // 但程序执行autorelease方法时，会将该对象添加到自动释放池中
    return [item autorelease];
}

// 重写该方法作为测试
- (void)dealloc {
    NSLog(@"Animal系统开始销毁我了,再见!");
    [super dealloc];
}

@end
