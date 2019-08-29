//
//  NSMutableArray+WJExtension.m
//  Demo
//
//  Created by sogubaby on 2019/4/3.
//  Copyright © 2019 sogubaby. All rights reserved.
//

#import "NSMutableArray+WJExtension.h"

@implementation NSMutableArray (WJExtension)

- (void)safeRemoveObjectAtIndex:(NSUInteger)index {
    if (self.count == 0 || index > self.count - 1) {
#ifndef DEBUG
        NSAssert3(false, @"%@ 数组大小:%tu, 游标%tu越界!", NSStringFromSelector(_cmd), self.count, index);
#else
//        NSLog(@"%@ 数组大小:%tu, 游标%tu越界!", NSStringFromSelector(_cmd), self.count, index);
#endif
        return;
    }
    [self removeObjectAtIndex:index];
}

- (void)safeAddObject:(id)anObject {
    if (anObject) {
        [self addObject:anObject];
    } else {
#ifndef DEBUG
        NSAssert1(false, @"%@ 空对象!", NSStringFromSelector(_cmd));
#else
        NSLog(@"%@ 空对象!", NSStringFromSelector(_cmd));
#endif
    }
}

@end
