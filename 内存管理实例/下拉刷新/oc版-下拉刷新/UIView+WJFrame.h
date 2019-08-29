//
//  UIView+WJFrame.h
//  内存管理实例
//
//  Created by 汪俊 on 2018/6/4.
//  Copyright © 2018年 汪俊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WJFrame)

@property (nonatomic, assign) CGFloat wj_x;
@property (nonatomic, assign) CGFloat wj_y;
@property (nonatomic, assign) CGFloat wj_width;
@property (nonatomic, assign) CGFloat wj_height;
@property (nonatomic, assign) CGFloat wj_centerX;
@property (nonatomic, assign) CGFloat wj_centerY;
@property (nonatomic, assign) CGSize wj_size;
@property (nonatomic, assign) CGFloat wj_top;
@property (nonatomic, assign) CGFloat wj_bottom;
@property (nonatomic, assign) CGFloat wj_left;
@property (nonatomic, assign) CGFloat wj_right;

@end
