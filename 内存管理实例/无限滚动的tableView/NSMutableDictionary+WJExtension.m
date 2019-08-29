//
//  NSDictionary+WJExtension.m
//  Demo
//
//  Created by sogubaby on 2019/4/8.
//  Copyright © 2019 sogubaby. All rights reserved.
//

#import "NSMutableDictionary+WJExtension.h"

@implementation NSMutableDictionary (WJExtension)

- (void)safeSetObject:(id)object forKey:(id)key {
    if (!object) {
//#ifdef DEBUG
//        NSAssert1(false, @"%@ 空对象!", NSStringFromSelector(_cmd));
//#else
        //        WJLog(@"%@ 空对象!", NSStringFromSelector(_cmd));
        // 记录日志
//#endif
        return;
    }
    if (!key) {
#ifdef DEBUG
        NSAssert1(false, @"%@ 空key!", NSStringFromSelector(_cmd));
#else
        //        NSLog(@"%@ 空key!", NSStringFromSelector(_cmd));
        // 记录日志
#endif
        return;
    }
    [self setObject:object forKey:key];
}

- (void)safeGetObjectWithKey:(id)key {
    

}
@end
