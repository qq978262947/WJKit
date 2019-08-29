//
//  ARCOwnershipAutoWeakVC.m
//  内存管理实例
//
//  Created by 汪俊 on 2018/5/7.
//  Copyright © 2018年 汪俊. All rights reserved.
//

#import "ARCOwnershipAutoWeakVC.h"

@interface ARCOwnershipAutoWeakVC ()

@end

@implementation ARCOwnershipAutoWeakVC

#pragma mark - Life Style
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self weakPrintOne];
//    [self weakPrintTwo];
}

#pragma mark - private
//查看模拟代码
- (void)simulationWeak {
    //1、
    {
        id __strong obj = [[NSObject alloc] init];
        id __weak obj1 = obj;
    }
    
    //等价代码如下:
    //id obj1;
    //objc_initWeak(&obj1, obj);
    //objc_destroyWeak(&obj1);
    
    //还等价于以下代码:
    //id obj1;
    //obj1 = 0;
    //objc_storeWeak(&obj1, obj);
    //objc_storeWeak(&obj1, 0);
    
    //2、
    {
        id __weak obj = [[NSObject alloc] init];
    }
    
    //等价代码如下;
    //id obj;
    //id tmp = objc_msgSend(NSObject, @selector(alloc));
    //objc_msgSend(tmp, @selector(init));
    //objc_initWeak(&obj, tmp);//初始化指针
    //objc_release(tmp); // 因为此时只有一个强引用，所以对象被释放了
    //objc_destroyWeak(&object);//将指针置为nil
}

//weak输出值
- (void)weakPrintOne
{
    //一赋值立马释放
    id __weak obj = [[NSObject alloc] init];
    NSLog(@"obj=%@", obj);//(null)
    
    //等价代码如下;
    //id obj;
    //id tmp = objc_msgSend(NSObject, @selector(alloc));
    //objc_msgSend(tmp, @selector(init));
    //objc_initWeak(&obj, tmp);//初始化指针
    //objc_release(tmp); // 因为此时只有一个强引用，所以对象被释放了
    //objc_destroyWeak(&object);//将指针置为nil
}

- (void)weakPrintTwo
{
    id __strong obj = [[NSObject alloc] init];
    id __weak obj1 = obj;
    NSLog(@"obj1 = %@",obj1);
    //这里有疑问，暂时不理解weak会把对象放到自动释放池中
    NSLog(@"count = %lu",_objc_rootRetainCount(obj1));//2 - 使用__weak修饰的变量会有一次retain操作，用完了就销毁了，所以此时为2
    NSLog(@"count = %lu",_objc_rootRetainCount(obj));//1
    //_objc_autoreleasePoolPrint();
    
    //等价代码如下:
    //id obj1;
    //objc_initWeak(&obj1, obj);
    //id tmp = objc_loadWeakRetained(&obj1);
    //objc_autorelease(tmp);
    //NSLog(@"%@", tmp);
    //objc_destroyWeak(&obj1);
}

//总结:
//1、__weak:不影响引用计数
//2、__weak:修饰的变量不持有对象
//3、被__weak修饰符修饰的变量会自动初始化为nil.
//4、__weak:持有某对象的弱引用时，若该对象被废弃时，则弱引用自动失效且处于nil
//5、__weak:修饰符只能用于IOS5以上的应用程序(ARC是IOS5推出的)、在IOS4程序中可以使用__unsafe_unretained修饰符代替
//6、__weak:不能用于MRC环境
//7、使用附有__weak 修饰符的变量，即是使用注册到autoreleasepool 中的对象
//8、objc_loadWeakRetained函数取出附有__ weak 修饰符变量所引用的对象并retain
//9、

@end
