//
//  ARCOwnershipAutoStrongVC.m
//  内存管理实例
//
//  Created by 汪俊 on 2018/5/7.
//  Copyright © 2018年 汪俊. All rights reserved.
//

#import "ARCOwnershipAutoStrongVC.h"

@interface ARCOwnershipAutoStrongVC ()

@end

@implementation ARCOwnershipAutoStrongVC

#pragma mark - Life Style
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - private
//查看模拟代码
- (void)simulationStrong {
    //1、
    {
        id __strong obj = [[NSObject alloc] init];
    }
    
    //等价代码如下:
    //{
    //    id obj = objc_msgSend(NSObject, @selector(alloc));
    //    objc_msgSend(obj, @selector(alloc));
    //    objc_release(obj);
    //}
    
    //2、
    {
        id __strong obj = [NSMutableArray array];
    }
    
    //等价于以下代码
    //{
    //    id obj = objc_msgSend(NSMutableArray, @selector(array));
    //    objc_retainAutoreleasedReturnValue(obj);
    //    objc_release(obj);
    //}
    
}

//3、
+ (id)array {
    return [[NSMutableArray alloc] init];
}

//等价于以下代码
//+ (id)array {
//    id obj = objc_msgSend(NSMutableArray, @selector(alloc));
//    objc_msgSend(obj, @selector(init));
//    return objc_autoreleaseReturnValue(obj);
//}


//总结:
//1、__strong:所有对象和id默认的类型;引用计数加1
//2、被__strong修饰符修饰的变量会自动初始化为nil.


@end
