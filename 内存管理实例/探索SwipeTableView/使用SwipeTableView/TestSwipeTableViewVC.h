//
//  TestSwipeTableViewVC.h
//  内存管理实例
//
//  Created by 汪俊 on 2018/5/18.
//  Copyright © 2018年 汪俊. All rights reserved.
//

#import <UIKit/UIKit.h>
#define RGBColorAlpha(r,g,b,f)   [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:f]
#define RGBColor(r,g,b)          RGBColorAlpha(r,g,b,1)

typedef NS_ENUM(NSInteger,STControllerType) {
    STControllerTypeNormal,
    STControllerTypeHybrid,
    STControllerTypeDisableBarScroll,
    STControllerTypeHiddenNavBar,
};

@interface TestSwipeTableViewVC : UIViewController

@property (nonatomic, assign) STControllerType type;
@property (nonatomic, strong) UIImageView * headerImageView;

@end
