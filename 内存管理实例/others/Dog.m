//
//  Dog.m
//  内存管理实例
//
//  Created by 汪俊 on 2018/4/18.
//  Copyright © 2018年 汪俊. All rights reserved.
//

#import "Dog.h"
typedef void (^Blk)(BOOL);
@implementation Dog

- (instancetype)init {
    if (self = [super init]) {
        NSLog(@"小狗出世了！初始引用计数为 %ld", self.retainCount);
    }
    return self;
}

- (void)dealloc {
    NSLog(@"小狗死了");
    [super dealloc];
}

- (void)testBlock {
    Blk block = ^(BOOL flag){
        return;
    };
    block(YES);
    return;
}

//int (^func()(int)) {
//    return ^(int count) {return count + 1;};
//}

- (instancetype(^)(int))getOneFunc {
//    __weak typeof(self) weakSelf = self;
    return ^(int count) {
//        [weakSelf testBlock];
//        Dog *dog = weakSelf;
        return [[Dog alloc]init];
    };
}

@end
