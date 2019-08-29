//
//  NSArray+WJExtension.m
//  Demo
//
//  Created by sogubaby on 2019/3/25.
//  Copyright © 2019 sogubaby. All rights reserved.
//

#import "NSArray+WJExtension.h"
//存放最多多少条历史记录📝
#define WJHistoryLength 50

@implementation NSArray (WJExtension)

- (id)safeObjectAtIndex:(long)index {
    if (self.count == 0 || index > self.count - 1) {
#ifndef DEBUG
        NSAssert3(false, @"%@ 数组大小:%tu, 游标%tu越界!", NSStringFromSelector(_cmd), self.count, index);
#endif
        return nil;
    }
    return [self objectAtIndex:index];
}

+ (void)storeHistoryString:(NSString *)str withKey:(NSString *)key {
    if (str.length == 0) return;
    NSMutableArray *historyArray = [NSMutableArray array];
    
    //从沙盒中取出上次存储的搜索纪录(取出用户上次的使用记录)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *checkHistory = [defaults objectForKey:key];
    // 是否重复
    if (![checkHistory containsObject:str]) {
        [historyArray addObject:str];
    }else {
        //        [historyArray removeObject:str];
        [historyArray addObject:str];
    }
    // 是否为空
    if (checkHistory == nil || checkHistory.count == 0|| checkHistory == NULL ) {
        
    }else if(checkHistory.count < WJHistoryLength){
        for (NSString *historyStr in checkHistory) {
            if (![historyArray containsObject:historyStr]) {
                [historyArray addObject:historyStr];
            }
        }
    }else {
        NSInteger number = checkHistory.count;
        if (number > WJHistoryLength) number = WJHistoryLength;
        for (int i = 0 ; i < number; i++) {
            NSString *historyStr = checkHistory[i];
            if (![historyArray containsObject:historyStr]) {
                if (historyArray.count < 5) [historyArray addObject:historyStr];
            }
        }
    }
    [defaults setObject:historyArray forKey:key];
    [defaults synchronize];
}

+ (void)deleteHistoryString:(NSString *)str withKey:(NSString *)key {
    //从沙盒中取出上次存储的搜索纪录(取出用户上次的使用记录)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *checkHistory = [defaults objectForKey:key];
    NSMutableArray *historyArray = [NSMutableArray array];
    
    NSInteger number = checkHistory.count;
    if (number > WJHistoryLength) number = WJHistoryLength;
    for (int i = 0 ; i < number; i++) {
        NSString *historyStr = checkHistory[i];
        if (![historyArray containsObject:historyStr]) {
            if (historyArray.count < 5) [historyArray addObject:historyStr];
        }
    }
    [historyArray removeObject:str];
    [defaults setObject:historyArray forKey:key];
    [defaults synchronize];
}

+ (void)replaceHistoryString:(NSString *)str
                  withString:(NSString *)replaceString
                      andKey:(NSString *)key {
    //从沙盒中取出上次存储的搜索纪录(取出用户上次的使用记录)
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *checkHistory = [NSMutableArray arrayWithArray:[defaults objectForKey:key]];
    if (str.length == 0 ||
        checkHistory.count <= 0) return;
    long index = [checkHistory indexOfObject:str];
    if (index >= checkHistory.count) return;
    if (![str isEqualToString:replaceString]) {//两次的内容不一样才进行替换
        [checkHistory replaceObjectAtIndex:index withObject:replaceString];
    }
    [defaults setObject:checkHistory forKey:key];
    [defaults synchronize];
}

+ (NSArray *)historyForKey:(NSString *)key {
    //从沙盒中取出上次存储的搜索纪录(取出用户上次的使用记录)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *checkHistory = [defaults objectForKey:key];
    return checkHistory;
}

+ (void)cleanHistoryArrayWithKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@[] forKey:key];
    [defaults synchronize];
    
}


@end
