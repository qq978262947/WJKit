//
//  WJRefreshHeader.h
//  内存管理实例
//
//  Created by 汪俊 on 2018/6/4.
//  Copyright © 2018年 汪俊. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WJRefreshHeader;

typedef void (^RefreshingBlock)(WJRefreshHeader *);

@interface WJRefreshHeader : UIView

+ (instancetype)headerWithRefreshingBlock:(RefreshingBlock)refreshingBlock;
+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

- (void)beganRefreshing;
- (void)endRefreshing;

@end
