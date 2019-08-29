//
//  TestRuntimeVC.m
//  内存管理实例
//
//  Created by 汪俊 on 2018/5/30.
//  Copyright © 2018年 汪俊. All rights reserved.
//

#import "TestRuntimeVC.h"
#import "NSObject+runtime.h"

@interface TestRuntimeVC ()

@end

@implementation TestRuntimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSLog(@"%@", [scrollView getAllProperties]);
//    [[UIScrollView new] printMothList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
