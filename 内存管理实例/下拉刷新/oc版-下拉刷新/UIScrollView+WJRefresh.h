//
//  UIScrollView+WJRefresh.h
//  内存管理实例
//
//  Created by 汪俊 on 2018/6/4.
//  Copyright © 2018年 汪俊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJRefreshHeader.h"

@interface UIScrollView (WJRefresh)

@property (nonatomic, strong) WJRefreshHeader *wj_header;

- (WJRefreshHeader *)refreshHeaderWithRefreshingBlock:(RefreshingBlock)refreshingBlock;

@end
