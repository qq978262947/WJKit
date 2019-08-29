//
//  EndScrollViewTool.m
//  内存管理实例
//
//  Created by 汪俊 on 2018/6/1.
//  Copyright © 2018年 汪俊. All rights reserved.
//

#import "EndScrollViewTool.h"

@implementation EndScrollViewTool

+ (void)scrollViewEndDecelerating:(UIScrollView *)scrollView {
    //    [scrollView isInterruptingDeceleration];
    [scrollView performSelector:@selector(_isInterruptingDeceleration) withObject:nil];
}

@end
