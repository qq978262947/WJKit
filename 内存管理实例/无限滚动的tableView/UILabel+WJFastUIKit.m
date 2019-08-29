//
//  UILabel+WJFastUIKit.m
//  Demo
//
//  Created by 汪俊 on 2019/6/14.
//  Copyright © 2019年 sogubaby. All rights reserved.
//

#import "UILabel+WJFastUIKit.h"

@implementation UILabel (WJFastUIKit)

- (WJLabelFrameBlock)wj_x {
    WJWeakSelf
    return ^(CGFloat value) {
        WJStrongSelf
        CGRect frame = strongSelf.frame;
        frame.origin.x = value;
        strongSelf.frame = frame;
        return strongSelf;
    };
}

- (WJLabelFrameBlock)wj_y {
    WJWeakSelf
    return ^(CGFloat value) {
        WJStrongSelf
        CGRect frame = strongSelf.frame;
        frame.origin.x = value;
        strongSelf.frame = frame;
        return strongSelf;
    };
}

- (WJLabelFrameBlock)wj_width {
    WJWeakSelf
    return ^(CGFloat value) {
        WJStrongSelf
        CGRect frame = strongSelf.frame;
        frame.size.width = value;
        strongSelf.frame = frame;
        return strongSelf;
    };
}

- (WJLabelFrameBlock)wj_height {
    WJWeakSelf
    return ^(CGFloat value) {
        WJStrongSelf
        CGRect frame = strongSelf.frame;
        frame.size.height = value;
        strongSelf.frame = frame;
        return strongSelf;
    };
}

- (WJLabelColorBlock)wj_bgColor {
    WJWeakSelf
    return ^(UIColor *color) {
        WJStrongSelf
        strongSelf.backgroundColor = color;
        return strongSelf;
    };
}

- (WJLabelAddViewBlock)wj_addSubView {
    WJWeakSelf
    return ^(UIView *view) {
        WJStrongSelf
        [strongSelf addSubview:view];
        return strongSelf;
    };
}

- (WJLabelAddViewBlock)wj_addToSuperView {
    WJWeakSelf
    return ^(UIView *view) {
        WJStrongSelf
        [view addSubview:strongSelf];
        return strongSelf;
    };
}

- (WJLabelTextBlock)wj_text {
    WJWeakSelf
    return ^(NSString *text) {
        WJStrongSelf
        strongSelf.text = text;
        return strongSelf;
    };
}

- (WJLabelColorBlock)wj_textColor {
    WJWeakSelf
    return ^(UIColor *color) {
        WJStrongSelf
        strongSelf.textColor = color;
        return strongSelf;
    };
}

@end
