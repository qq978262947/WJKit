//
//  UIView+WJFrame.m
//  内存管理实例
//
//  Created by 汪俊 on 2018/6/4.
//  Copyright © 2018年 汪俊. All rights reserved.
//

#import "UIView+WJFrame.h"

@implementation UIView (WJFrame)

- (CGFloat)wj_x {
    return self.frame.origin.x;
}

- (void)setWj_x:(CGFloat)x {
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}

- (CGFloat)wj_y {
    return self.frame.origin.y;
}

- (void)setWj_y:(CGFloat)y {
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}

- (CGFloat)wj_width {
    return self.frame.size.width;
}

- (void)setWj_width:(CGFloat)width {
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

- (CGFloat)wj_height {
    return self.frame.size.height;
}

- (void)setWj_height:(CGFloat)height {
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

- (CGFloat)wj_centerX {
    return self.center.x;
}

- (void)setWj_centerX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)wj_centerY {
    return self.center.y;
}

- (void)setWj_centerY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGSize)wj_size {
    return self.frame.size;
}

- (void)setWj_size:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)wj_top {
    return self.frame.origin.y;
}

- (void)setWj_top:(CGFloat)t {
    self.frame = CGRectMake(self.wj_left, t, self.wj_width, self.wj_height);
}

- (CGFloat)wj_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setWj_bottom:(CGFloat)b {
    self.frame = CGRectMake(self.wj_left, b - self.wj_height, self.wj_width, self.wj_height);
}

- (CGFloat)wj_left {
    return self.frame.origin.x;
}

- (void)setWj_left:(CGFloat)l {
    self.frame = CGRectMake(l, self.wj_top, self.wj_width, self.wj_height);
}

- (CGFloat)wj_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setWj_right:(CGFloat)r {
    self.frame = CGRectMake(r - self.wj_width, self.wj_top, self.wj_width, self.wj_height);
}


@end
