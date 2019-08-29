//
//  NSMutableArray+WJExtension.h
//  Demo
//
//  Created by sogubaby on 2019/4/3.
//  Copyright © 2019 sogubaby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (WJExtension)

// 移除对应的角标
- (void)safeRemoveObjectAtIndex:(NSUInteger)index;
- (void)safeAddObject:(id)anObject;

@end
