//
//  AutoReleaseMemoryViewController.m
//  内存管理实例
//
//  Created by 汪俊 on 2018/4/28.
//  Copyright © 2018年 汪俊. All rights reserved.
//

#import "AutoReleaseMemoryViewController.h"



@interface AutoReleaseMemoryViewController ()

@end

@implementation AutoReleaseMemoryViewController

#pragma mark - life style

//当前可以在ARC也可以在MRC环境下执行、这里是MRC环境
//在MRC下使用NSAutoreleasePool
//在ARC下使用@autoreleasepool{}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //测试内存
    [self testMemory];
    
}

#pragma mark - private
- (void)testMemory {
//    for (int i = 0; i < 1000000; i++) {
//        //这里的前提是中间部分代码有autorelease对象产生
//        //NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//
//        //在MRC下,如果系统方法不是以alloc、new、copy、mutableCopy开头
//        //一般返回的都是[obj autorelease]
//        NSString *string = @"Abc";
//        if (i % 10 == 0) { // 节省时间
//            string = [string lowercaseString];
//            string = [string stringByAppendingString:@"xyz"];
//            NSLog(@"%@", string);
//        }
//        //[pool release];
//    }
    
    for (int i = 0; i < 100000; i ++) {
        @autoreleasepool { // 注释内存会加到恐怖的113，而加上会在90多m,然后都会落下。arc环境下会有一些作用，MRC环境下，加上内存少许波动，而不加内存激增到200M+再落下
            UILabel *label  = [[UILabel alloc]init];
            NSLog(@"%i", i);
        }
    }
//    结论：若果没有循环中的pool, 那么直到结束循环之前，这1000000个autorelease 临时对象都不会被释放掉，占用大量内存。
}

@end
