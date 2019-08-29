//
//  DemoConfigurationModel.m
//  内存管理实例
//
//  Created by 汪俊 on 2018/4/28.
//  Copyright © 2018年 汪俊. All rights reserved.
//

#import "DemoConfigurationModel.h"

@implementation DemoConfigurationModel

- (instancetype)initWithDemoItemTitleName:(NSString *)demoItemTitleName demoItemClassName:(NSString *)demoItemClassName demoItemNextPageArray:(NSArray *)demoItemNextPageArray  demoItemMethodNameBlock:(DemoItemMethodNameBlock)demoItemMethodNameBlock {
    if (self = [super init]) {
        _demoItemTitleName = [demoItemTitleName copy];
        _demoItemClassName = [demoItemClassName copy];
        _demoItemNextPageArray = [demoItemNextPageArray copy];
        _demoItemMethodNameBlock = [demoItemMethodNameBlock copy];
    }
    return self;
}

+ (instancetype)configurationModelWithDemoItemTitleName:(NSString *)demoItemTitleName demoItemClassName:(NSString *)demoItemClassName {
    return [[self alloc]initWithDemoItemTitleName:demoItemTitleName demoItemClassName:demoItemClassName demoItemNextPageArray:nil demoItemMethodNameBlock:nil];
}

+ (instancetype)configurationModelWithDemoItemTitleName:(NSString *)demoItemTitleName demoItemMethodNameBlock:(DemoItemMethodNameBlock)demoItemMethodNameBlock {
    return [[self alloc]initWithDemoItemTitleName:demoItemTitleName demoItemClassName:nil demoItemNextPageArray:nil demoItemMethodNameBlock:demoItemMethodNameBlock];
}

+ (instancetype)configurationModelWithDemoItemTitleName:(NSString *)demoItemTitleName demoItemNextPageArray:(NSArray *)demoItemNextPageArray {
    return [[self alloc]initWithDemoItemTitleName:demoItemTitleName demoItemClassName:nil demoItemNextPageArray:demoItemNextPageArray demoItemMethodNameBlock:nil];
}

@end
