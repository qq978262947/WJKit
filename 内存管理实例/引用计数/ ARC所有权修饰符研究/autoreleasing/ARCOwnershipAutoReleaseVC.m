//
//  ARCOwnershipAutoReleaseVC.m
//  内存管理实例
//
//  Created by 汪俊 on 2018/5/7.
//  Copyright © 2018年 汪俊. All rights reserved.
//

#import "ARCOwnershipAutoReleaseVC.h"

@interface ARCOwnershipAutoReleaseVC ()

@end

@implementation ARCOwnershipAutoReleaseVC

//当前要在ARC环境下执行！！！
#pragma mark - Life Style
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self autoreleaseStudy];
}

#pragma mark - private
//查看模拟代码
- (void)simulationAutoRelease {
    @autoreleasepool {
        id __autoreleasing obj = [[NSObject alloc] init];
    }
    
    //等价代码如下:
    //id pool = objc_autoreleasePoolPush();
    
    //id obj = objc_msgSend(NSObject, @selector(alloc));
    //objc_msgSend(obj, @selector(init));
    //objc_autorelease(obj);//这里又添加到自动释放池中了
    
    //objc_autoreleasePoolPop(pool);
    
    //等价MRC代码:
    //NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    //id obj = [[NSObject alloc] init];
    //[obj autorelease];
    //[pool drain];
    
    
    @autoreleasepool {
        id __autoreleasing obj = [NSMutableArray array];
    }
    
    //等价代码如下:
    //id pool = objc_autoreleasePoolPush();
    
    //id obj = objc_msgSend(NSMutableArray, @selector(array));
    //objc_retainAutoreleasedReturnValue(obj);//类似于alloc
    //objc_autorelease(obj);//又将其加入自动释放池
    
    //objc_autoreleasePoolPop(pool);
}

#pragma mark - __autoreleasing修饰符
- (void)autoreleaseStudy {
//    [self autoreleaseStudyOne];
//    [self autoreleaseStudyTwo];
    [self autoreleaseStudyThree];
    //[self autoreleaseStudyFour];
}

//崩溃1
- (void)autoreleaseStudyOne {
    id __unsafe_unretained target = nil;
    
    @autoreleasepool {
        id __autoreleasing temp = [[NSObject alloc]init];
        target = temp;
        NSLog(@"temp = %@", temp);
    }
    NSLog(@"target = %@", target);
}//这里会崩溃,虽然加入了自动释放池,但是超出自动释放池范围,对象一样被销毁

//崩溃2
- (void)autoreleaseStudyTwo {
    id __unsafe_unretained target = nil;
    
    @autoreleasepool {
        id  temp = [[NSObject alloc]init];
        target = temp;
        NSLog(@"temp = %@", temp);
    }
    NSLog(@"target = %@", target);
}//这里会崩溃,超出作用域被编译器插入objc_release方法释放掉

//不崩溃3
- (void)autoreleaseStudyThree {
    id __unsafe_unretained target = nil;
    {
        //temp被注册到自动释放池中
        id __autoreleasing temp = [NSMutableArray array];
        [temp addObject:@"obj"];
        target = temp;
        NSLog(@"temp.retainCount = %lu",_objc_rootRetainCount(temp));
    }//temp在自动释放池中,超出大括号,也没有被销毁
    NSLog(@"target = %@",target);
    NSLog(@"target.retainCount = %lu" ,_objc_rootRetainCount(target));
//  id obj = objc_msgSend(NSMutableArray, @selector(array));
    //  objc_retainAutoreleasedReturnValue(obj);
    //大概意思就是：如果value为空，这个函数无效，否则，它会试图从对value的objc_autoreleaseReturnValue函数的调用中接受一个保留计数的移交，在最近被调用的函数中或者它调用的。如果失败，它执行一个和objc_retain完全一样的保留操作。
//    我们来看看objc_autoreleaseReturnValue函数的解释：
//    大概意思就是：如果value为空，这个函数无效，否则，它会执行一个高效的保留计数持有者的移交，从对象上面，到封闭的调用帧里，调用objc_retainAutoreleasedReturnValue的相同对象，如果这是不可能的，那么这个对象会被自动释放就像objc_autorelease调用一样。
//  objc_retainAutoreleasedReturnValue函数主要用于最优化程序运行，顾名思义，它是用于自己持有(retain)对象的函数，但是它持有的对象应为返回注册在autoreleasepool中对象的方法，或是函数的返回值。像该源码这样，在调用alloc/new/copy/mutableCopy以外的方法，即NSMutableArray的 array类方法等调用之后，由编译器插入该函数。
//    简单的说就是走的不是同一体系
    
//  objc_release(obj);
}

//不崩溃4
- (void)autoreleaseStudyFour {
    id __unsafe_unretained target = nil;
    {
        //被注册到自动释放池中了
        id __autoreleasing temp = [[NSMutableArray alloc]init];
        [temp addObject:@"obj"];
        target = temp;
        NSLog(@"temp.retainCount = %lu",_objc_rootRetainCount(temp));
    }//temp在自动释放池中,超出大括号,也没有被销毁
    NSLog(@"target = %@",target);
    NSLog(@"target.retainCount = %lu" ,_objc_rootRetainCount(target));
}

//总结:
//1、在ARC下__autoreleasing代替了autorelease
//2、以下两种情况默认是添加了__autoreleasing修饰符
//   a、对象作为函数的返回值，编译器会自动将其注册到自动释放池<ARC对其进行了优化>
//   b、id的指针或对象的指针在没有显示指定时会被附加上__autoreleasing修饰符
//3、参考网址:
//   https://blog.csdn.net/junjun150013652/article/details/53149145
//   http://blog.sunnyxx.com/2014/10/15/behind-autorelease/


@end
