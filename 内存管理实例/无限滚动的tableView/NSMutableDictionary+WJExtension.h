//
//  NSDictionary+WJExtension.h
//  Demo
//
//  Created by sogubaby on 2019/4/8.
//  Copyright © 2019 sogubaby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (WJExtension)

// 避免崩溃的方法 代替objctAtIndex和【index】
- (void)safeSetObject:(id)object forKey:(id)key;

@end

