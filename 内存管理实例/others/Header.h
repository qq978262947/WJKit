//
//  Header.h
//  内存管理实例
//
//  Created by 汪俊 on 2018/5/3.
//  Copyright © 2018年 汪俊. All rights reserved.
//

#ifndef Header_h
#define Header_h

#define WJWeakSelf __weak typeof(self)weakSelf = self;
#define WJStrongSelf __strong typeof(self)self = weakSelf; // 可以和上面配套使用
#import <UIKit/UIKit.h> // uintptr_t在uikit框架下，所以需要导入
extern void _objc_autoreleasePoolPrint(void);//打印注册到自动释放池中的对象
extern uintptr_t _objc_rootRetainCount(id obj);//获取对象的引用计数

#endif /* Header_h */
