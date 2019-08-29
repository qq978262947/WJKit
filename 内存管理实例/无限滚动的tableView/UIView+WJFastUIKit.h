//
//  UIView+WJFastUIKit.h
//  Demo
//
//  Created by 汪俊 on 2019/6/14.
//  Copyright © 2019年 sogubaby. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef UIView*(^WJFrameBlock)(CGFloat value);
typedef UIView*(^WJColorBlock)(UIColor *color);
typedef UIView*(^WJAddViewBlock)(UIView *view);
#define createView(name) UIView *name = [UIView new];\
name

@interface UIView (WJFastUIKit)

@property (nonatomic, copy, readonly) WJFrameBlock wj_x;
@property (nonatomic, copy, readonly) WJFrameBlock wj_y;
@property (nonatomic, copy, readonly) WJFrameBlock wj_width;
@property (nonatomic, copy, readonly) WJFrameBlock wj_height;

@property (nonatomic, copy, readonly) WJColorBlock wj_bgColor;

@property (nonatomic, copy, readonly) WJAddViewBlock wj_addSubView;
@property (nonatomic, copy, readonly) WJAddViewBlock wj_addToSuperView;

@end

