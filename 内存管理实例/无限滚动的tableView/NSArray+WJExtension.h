//
//  NSArray+WJExtension.h
//  Demo
//
//  Created by sogubaby on 2019/3/25.
//  Copyright © 2019 sogubaby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (WJExtension)

// 避免崩溃的方法 代替objctAtIndex和【index】
- (id)safeObjectAtIndex:(long)index;

// 临时解决方案
+ (void)storeHistoryString:(NSString *)str withKey:(NSString *)key;
+ (void)deleteHistoryString:(NSString *)str withKey:(NSString *)key;
+ (NSArray *)historyForKey:(NSString *)key;
+ (void)replaceHistoryString:(NSString *)str
                  withString:(NSString *)replaceString
                      andKey:(NSString *)key;
+ (void)cleanHistoryArrayWithKey:(NSString *)key;

@end

