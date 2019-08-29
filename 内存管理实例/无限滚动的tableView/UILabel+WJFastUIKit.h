//
//  UILabel+WJFastUIKit.h
//  Demo
//
//  Created by 汪俊 on 2019/6/14.
//  Copyright © 2019年 sogubaby. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef UILabel*(^WJLabelFrameBlock)(CGFloat value);
typedef UILabel*(^WJLabelColorBlock)(UIColor *color);
typedef UILabel*(^WJLabelAddViewBlock)(UIView *view);
typedef UILabel*(^WJLabelTextBlock)(NSString *text);
#define createLabel(name) UILabel *name = [UILabel new];\
name

@interface UILabel (WJFastUIKit)

@property (nonatomic, copy, readonly) WJLabelFrameBlock wj_x;
@property (nonatomic, copy, readonly) WJLabelFrameBlock wj_y;
@property (nonatomic, copy, readonly) WJLabelFrameBlock wj_width;
@property (nonatomic, copy, readonly) WJLabelFrameBlock wj_height;

@property (nonatomic, copy, readonly) WJLabelColorBlock wj_bgColor;

@property (nonatomic, copy, readonly) WJLabelAddViewBlock wj_addSubView;
@property (nonatomic, copy, readonly) WJLabelAddViewBlock wj_addToSuperView;

@property (nonatomic, copy, readonly) WJLabelTextBlock wj_text;
@property (nonatomic, copy, readonly) WJLabelColorBlock wj_textColor;

@end
