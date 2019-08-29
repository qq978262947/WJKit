//
//  InterceptedObjectsMRCVC.m
//  内存管理实例
//
//  Created by 汪俊 on 2018/5/7.
//  Copyright © 2018年 汪俊. All rights reserved.
//

#import "InterceptedObjectsMRCVC.h"
#import "MyClazz.h"

@interface InterceptedObjectsMRCVC ()

@end

@implementation InterceptedObjectsMRCVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    MyClazz *obj = [[[MyClazz alloc] init] autorelease];
    [obj test];
}


@end
