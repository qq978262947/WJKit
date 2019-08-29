//
//  HighCopyAutorealeasePool.m
//  内存管理实例
//
//  Created by 汪俊 on 2018/4/23.
//  Copyright © 2018年 汪俊. All rights reserved.
//

#import "HighCopyAutorealeasePool.h"


// 做一款高仿的自动释放池
@implementation HighCopyAutorealeasePool
/**
// push操作 （压栈）
void *objc_autoreleasePoolPush(void) {
    if (UseGC) return nil;
    return AutoreleasePoolPage::push();
}

//    pop 操作
static inline void *push() {
    id *dest = autoreleaseFast(POOL_SENTINEL);
    assert(*dest == POOL_SENTINEL);
    return dest;
}

//    push 函数通过调用 autoreleaseFast 函数来执行具体的插入操作。
static inline id *autoreleaseFast(id obj) {
    AutoreleasePoolPage *page = hotPage();
    if (page && !page->full()) {
        return page->add(obj);
    } else if (page) {
        return autoreleaseFullPage(obj, page);
    } else {
        return autoreleaseNoPage(obj);
    }
}

//    autorelease 操作
- (id)autorelease {
    return ((id)self)->rootAutorelease();
}
*/

@end
