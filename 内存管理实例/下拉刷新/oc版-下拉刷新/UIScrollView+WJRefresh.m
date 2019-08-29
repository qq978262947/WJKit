//
//  UIScrollView+WJRefresh.m
//  内存管理实例
//
//  Created by 汪俊 on 2018/6/4.
//  Copyright © 2018年 汪俊. All rights reserved.
//

#import "UIScrollView+WJRefresh.h"
#import <objc/runtime.h>

@implementation UIScrollView (WJRefresh)

- (WJRefreshHeader *)wj_header {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setWj_header:(WJRefreshHeader *)wj_header {
    [self.wj_header removeFromSuperview];
    [self addSubview:wj_header];
    
    SEL key = @selector(wj_header);
    objc_setAssociatedObject(self, key, wj_header, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (WJRefreshHeader *)refreshHeaderWithRefreshingBlock:(RefreshingBlock)refreshingBlock {
    WJRefreshHeader *header = [WJRefreshHeader headerWithRefreshingBlock:refreshingBlock];
    self.wj_header = header;
    return header;
}

@end
