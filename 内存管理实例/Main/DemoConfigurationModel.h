//
//  DemoConfigurationModel.h
//  内存管理实例
//
//  Created by 汪俊 on 2018/4/28.
//  Copyright © 2018年 汪俊. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^DemoItemMethodNameBlock)(NSString * title);

@interface DemoConfigurationModel : NSObject

@property (nonatomic, copy, readonly) NSString *demoItemTitleName;
@property (nonatomic, copy, readonly) NSString *demoItemClassName;
@property (nonatomic, copy, readonly) NSArray *demoItemNextPageArray;
@property (nonatomic, copy, readonly) DemoItemMethodNameBlock demoItemMethodNameBlock;
+ (instancetype)configurationModelWithDemoItemTitleName:(NSString *)demoItemTitleName demoItemMethodNameBlock:(DemoItemMethodNameBlock)demoItemMethodNameBlock; // 定制跳转动作在block中
+ (instancetype)configurationModelWithDemoItemTitleName:(NSString *)demoItemTitleName demoItemClassName:(NSString *)demoItemClassName;        // 跳转到指定的类-demoItemClassName为类名
+ (instancetype)configurationModelWithDemoItemTitleName:(NSString *)demoItemTitleName demoItemNextPageArray:(NSArray *)demoItemNextPageArray; // 跳转到下一页专用

@end
