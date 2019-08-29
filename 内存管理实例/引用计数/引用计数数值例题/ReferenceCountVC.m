//
//  ReferenceCountVC.m
//  内存管理实例
//
//  Created by 汪俊 on 2018/5/7.
//  Copyright © 2018年 汪俊. All rights reserved.
//

#import "ReferenceCountVC.h"

@interface ReferenceCountVC ()

@end

@implementation ReferenceCountVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self referenceCountOne];
    [self referenceCountTwo];
    [self referenceCountThree];
    [self referenceCountFour];
    [self referenceCountFive];
}

//引用计数1
- (void)referenceCountOne {
    id __strong obj = [[NSObject alloc] init];
    NSLog(@"retainCount-1 = %lu", _objc_rootRetainCount(obj)); //1
}

//引用计数2
- (void)referenceCountTwo {
    id __strong obj = [[NSObject alloc] init];
    id __weak o = obj;
    NSLog(@"retainCount-2 = %lu", _objc_rootRetainCount(obj)); //1
}

//引用计数3
- (void)referenceCountThree {
    @autoreleasepool{
        id __strong obj = [[NSObject alloc] init];
        id __autoreleasing o = obj;
        //被强引用了,又被注册到自动释放池
        NSLog(@"retainCount-3 = %lu", _objc_rootRetainCount(obj)); //2
    }
}

//引用计数4
- (void)referenceCountFour {
    id __strong obj = [[NSObject alloc] init];
    @autoreleasepool{
        id __autoreleasing o = obj;
        //被强引用了,又被注册到自动释放池
        NSLog(@"retainCount-4 = %lu", _objc_rootRetainCount(obj));//2
    }
    //自动释放池里面的被释放了
    NSLog(@"retainCount-5 = %lu",_objc_rootRetainCount(obj));//1
}

//引用计数5
- (void)referenceCountFive {
    @autoreleasepool{
        id __strong obj = [[NSObject alloc] init];
        //_objc_autoreleasePoolPrint();
        NSLog(@"before using __weak: retain count = %lu" ,_objc_rootRetainCount(obj));
        
        id __weak o = obj;
        NSLog(@"class = %@",[o class]);
        
        //这里和weak同样有疑问??不明白引用计数的变化
        NSLog(@"after using __weak: retain count = %lu" ,_objc_rootRetainCount(obj)); //1
        NSLog(@"after using __weak: retain count = %lu" ,_objc_rootRetainCount(o)); //2
        
        //_objc_autoreleasePoolPrint();
    }
}


//引用计数1
- (void)autoreleaseStudyOne {
    @autoreleasepool {
        id __strong obj = [[NSObject alloc] init];
        id __autoreleasing o = obj;
        NSLog(@"retain count = %lu", _objc_rootRetainCount(obj));
    }
}

//引用计数2
- (void)autoreleaseStudyTwo {
    @autoreleasepool {
        id __autoreleasing obj = [[NSObject alloc] init];
        NSLog(@"retain count = %lu", _objc_rootRetainCount(obj));
    }
}

@end
