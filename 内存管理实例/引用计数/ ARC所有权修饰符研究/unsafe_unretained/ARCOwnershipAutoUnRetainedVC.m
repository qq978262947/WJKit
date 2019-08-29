//
//  ARCOwnershipAutoUnRetainedVC.m
//  内存管理实例
//
//  Created by 汪俊 on 2018/5/7.
//  Copyright © 2018年 汪俊. All rights reserved.
//

#import "ARCOwnershipAutoUnRetainedVC.h"

@interface ARCOwnershipAutoUnRetainedVC ()

@end

@implementation ARCOwnershipAutoUnRetainedVC

#pragma mark - Life Style
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self testOne];
}

#pragma mark - private
//查看模拟代码
- (void)simulationUnRetained {
    {
        id __unsafe_unretained obj = [[NSObject alloc] init];
    }
    
    //等价代码如下:
    //{
    //    id obj = objc_msgSend(NSObject, @selector(alloc));
    //    objc_msgSend(obj, @selector(init));
    //    objc_release(obj);
    //}
}

/*
 * 研究__weak和__unsafe_unretained区别
 **/
- (void)testOne {
    @try {
        //1、这里会提示对象会立即释放
        id __weak objOne = [[NSObject alloc]init];
        NSLog(@"objOne = %@",objOne);
    } @catch (NSException *exception) {
        NSLog(@"objOne崩溃了");
    }

    @try {
        //2、这里会提示对象会立即释放
        id __unsafe_unretained objTwo = [[NSObject alloc]init];
//        NSLog(@"objTwo = %@",objTwo); // 这里objTwo已经被释放了
    } @catch (NSException *exception) {
        NSLog(@"objTwo崩溃了");
    }

    @try {
        //3、以上都会提示对象释放，到底有什么区别呢
        //这里会崩溃,这里的指针不会变为nil,还是指向一段已经释放的内存
        id __unsafe_unretained objThree = [[NSMutableArray alloc]init];
//        [objThree addObject:@"obj"];
    } @catch (NSException *exception) {
        NSLog(@"objThree崩溃了");
    }

    @try {
        //这里不会崩溃,objThree会自动变为nil,对nil发送消息不会崩溃
        id __weak objFour = [[NSMutableArray alloc]init];
        [objFour addObject:@"obj"];
    } @catch (NSException *exception) {
        NSLog(@"objFour崩溃了");
    }
    
    @try {
        //4、以下代码依然会崩溃,原因是obj0超出作用域失效,obj1既不强引用也不弱引用,因此对象就被释放了.
        //但是obj1还是指向这块回收的内存区域,出现野指针.
        id __unsafe_unretained obj1 = nil;
        {
            id  obj0 = [[NSMutableArray alloc]init];
            [obj0 addObject:@"obj"];
            obj1 = obj0;
            NSLog(@"obj0 = %@", obj0);
        }
        NSLog(@"obj1 = %@", obj1);
    } @catch (NSException *exception) {
        NSLog(@"最后一段也崩溃了");
    }
}


//总结:
//1、__unsafe_unretained:不持有对象的强引用也不持有弱引用
//2、__unsafe_unretained与__weak的区别：
//  a、__weak只能用于ARC,也就是IOS5以后;__unsafe_unretained无限制
//  b、__weak持有对象的弱引用,当对象被废弃时,则弱引用自动失效且处于nil
//  c、__unsafe_unretained不持有对象的弱引用也不弱引用,当对象被废弃时,指针不会自动处于nil,还指向原来的内存区域,容易出现野指针
//  d、ARC的内存管理工作是编译器的工作，但是__unsafe_unretained修饰的变量不属于编译器的内存管理对象

@end
