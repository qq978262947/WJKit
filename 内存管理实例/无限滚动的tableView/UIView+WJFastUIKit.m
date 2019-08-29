//
//  UIView+WJFastUIKit.m
//  Demo
//
//  Created by 汪俊 on 2019/6/14.
//  Copyright © 2019年 sogubaby. All rights reserved.
//

#import "UIView+WJFastUIKit.h"

@implementation UIView (WJFastUIKit)

- (WJFrameBlock)wj_x {
    WJWeakSelf
    return ^(CGFloat value) {
        WJStrongSelf
        CGRect frame = strongSelf.frame;
        frame.origin.x = value;
        self.frame = frame;
        return strongSelf;
    };
}

- (WJFrameBlock)wj_y {
    WJWeakSelf
    return ^(CGFloat value) {
        WJStrongSelf
        CGRect frame = strongSelf.frame;
        frame.origin.x = value;
        strongSelf.frame = frame;
        return strongSelf;
    };
}

- (WJFrameBlock)wj_width {
    WJWeakSelf
    return ^(CGFloat value) {
        WJStrongSelf
        CGRect frame = strongSelf.frame;
        frame.size.width = value;
        strongSelf.frame = frame;
        return strongSelf;
    };
}

- (WJFrameBlock)wj_height {
    WJWeakSelf
    return ^(CGFloat value) {
        WJStrongSelf
        CGRect frame = strongSelf.frame;
        frame.size.height = value;
        strongSelf.frame = frame;
        return strongSelf;
    };
}

- (WJColorBlock)wj_bgColor {
    WJWeakSelf
    return ^(UIColor *color) {
        WJStrongSelf
        strongSelf.backgroundColor = color;
        return strongSelf;
    };
}

- (WJAddViewBlock)wj_addSubView {
    WJWeakSelf
    return ^(UIView *view) {
        WJStrongSelf
        [strongSelf addSubview:view];
        return strongSelf;
    };
}

- (WJAddViewBlock)wj_addToSuperView {
    WJWeakSelf
    return ^(UIView *view) {
        WJStrongSelf
        [view addSubview:strongSelf];
        return strongSelf;
    };
}

@end
