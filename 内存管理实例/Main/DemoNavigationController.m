//
//  DemoNavigationController.m
//  内存管理实例
//
//  Created by 汪俊 on 2018/4/28.
//  Copyright © 2018年 汪俊. All rights reserved.
//

#import "DemoNavigationController.h"

@interface DemoNavigationController ()

@end

@implementation DemoNavigationController

#pragma mark - life style
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    if (viewController.navigationController.topViewController != viewController) {
        // 全局添加返回按钮 - 发现系统有默认的，就用它了
    }
}

@end
