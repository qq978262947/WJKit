//
//  NSObject+runtime.h
//  内存管理实例
//
//  Created by 汪俊 on 2018/5/30.
//  Copyright © 2018年 汪俊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (runtime)

//1、/* 获取对象的所有属性，不包括属性值 */
- (NSArray *)getAllProperties;
//2、/* 获取对象的所有属性 以及属性值 */
- (NSDictionary *)properties_aps;
//3、/* 获取对象的所有方法 */
- (void)printMothList;

@end
