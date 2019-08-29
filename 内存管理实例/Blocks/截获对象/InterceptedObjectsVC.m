//
//  InterceptedObjectsVC.m
//  内存管理实例
//
//  Created by 汪俊 on 2018/5/7.
//  Copyright © 2018年 汪俊. All rights reserved.
//

#import "InterceptedObjectsVC.h"

//声明block类型
typedef void (^blk_O)(id obj);

@interface InterceptedObjectsVC ()

@end

@implementation InterceptedObjectsVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //截获对象并使用对象
    //[self interceptedObjectsUse];
    //截获对象并赋值
    //[self interceptedObjectsAssignment];
}

//截获对象并使用对象--无问题
- (void)interceptedObjectsUse {
    NSMutableArray *array = [[NSMutableArray alloc]init];
    void (^blk)(id) = ^(id obj){
        [array addObject:obj];
        NSLog(@"array.count = %lu",(unsigned long)array.count);//2
    };
    
    [array addObject:@"obj"];
    blk([[NSObject alloc]init]);
}

//截获对象并赋值--会有问题
- (void)interceptedObjectsAssignment {
    __block NSMutableArray *array = [[NSMutableArray alloc]init];
    void (^blk)(void) = ^{
        //不加__block,这里会报错
        array = [[NSMutableArray alloc]init];
    };
    
    blk();
}

//总结:
//1、如果对象是局部变量,在不加__block的情况下,只能截获使用,不能重新赋值
//2、如果对象是静态变量、静态全局变量、全局变量,则可以进行截取并使用

@end
