//
//  UIScrollView+WJFrame.m
//  内存管理实例
//
//  Created by 汪俊 on 2018/6/5.
//  Copyright © 2018年 汪俊. All rights reserved.
//

#import "UIScrollView+WJFrame.h"

@implementation UIScrollView (WJFrame)

- (void)setWj_contentInsetTop:(CGFloat)contentInsetTop {
    UIEdgeInsets inset = self.contentInset;
    inset.top = contentInsetTop;
    self.contentInset = inset;
}

- (CGFloat)wj_contentInsetTop {
    return self.contentInset.top;
}

- (void)setWj_contentOffsetY:(CGFloat)wj_contentOffsetY {
    CGPoint contentOffset = self.contentOffset;
    contentOffset.y = wj_contentOffsetY;
    self.contentOffset = contentOffset;
}

- (CGFloat)wj_contentOffsetY {
    return self.contentOffset.y;
}

@end
