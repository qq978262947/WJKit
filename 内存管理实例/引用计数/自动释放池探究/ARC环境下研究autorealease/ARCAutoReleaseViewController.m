//
//  ARCAutoReleaseViewController.m
//  内存管理实例
//
//  Created by 汪俊 on 2018/5/4.
//  Copyright © 2018年 汪俊. All rights reserved.
//

#import "ARCAutoReleaseViewController.h"
#import "NSObject+Category.h"

@interface ARCAutoReleaseViewController ()


@end

@implementation ARCAutoReleaseViewController

#pragma mark - life style
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self systemClassMethodStudy];
    [self customizeClassMethodStudy];
}

#pragma mark - 系统方法
- (void)systemClassMethodStudy {
//    [self systemClassMethodStudyOne];
//    [self systemClassMethodStudyTwo];
//    [self systemClassMethodStudyThree];
}

#pragma mark - 自定义方法
- (void)customizeClassMethodStudy {
//    [self customizeClassMethodStudyOne];
//    [self customizeClassMethodStudyTwo];
//    [self customizeClassMethodStudyThree];
//    [self customizeClassMethodStudyFour];
    
//    [self customizeClassMethodStudyFive];
//    [self customizeClassMethodStudySix];
//    [self customizeClassMethodStudySeven];
//    [self customizeClassMethodStudyEight];
}

//系统类方法-1-崩溃
- (void)systemClassMethodStudyOne {
    id __unsafe_unretained target = nil; // __unsafe_unretained可以理解为__weak
    {
        //temp没有被注册到自动释放池中
        id temp = [NSMutableArray array];
        [temp addObject:@"obj"];
        target = temp;
        NSLog(@"temp = %@",temp);
        _objc_autoreleasePoolPrint();
    }//超出作用域,temp所指对象就被销毁,target还指向一段被回收的内存,所以崩溃
    NSLog(@"target = %@",target);
    
    //大括号中的等价内容<详情见Objective-C高级编程p62>：
    {
        //objc_retainAutoreleasedReturnValue函数与objc_retain函数不同，它即便不注册到autoreleasepool中而返回对象，也能够正确地获取对象
        
        //id temp = objc_msgSend(NSMutableArray, @selector(array));
        //...
        //objc_release(temp);
    }

    // 崩溃打印信息如下
//    2018-05-10 15:47:05.088776+0800 内存管理实例[13101:974011] temp = (
//    obj
//    )
//    objc[13101]: ##############
//    objc[13101]: AUTORELEASE POOLS for thread 0x10860f340
//        objc[13101]: 65 releases pending.
//        objc[13101]: [0x7f854e003000]  ................  PAGE  (hot) (cold)
//        objc[13101]: [0x7f854e003038]  ################  POOL 0x7f854e003038
//        objc[13101]: [0x7f854e003040]    0x600000031900  __NSCFString
//        objc[13101]: [0x7f854e003048]  ################  POOL 0x7f854e003048
//        objc[13101]: [0x7f854e003050]    0x7f854d5271b0  UITableViewCellSelectedBackground
//        objc[13101]: [0x7f854e003058]    0x7f854d70f8c0  UIWindow
//        objc[13101]: [0x7f854e003060]    0x7f854d401d70  UIScreen
//        objc[13101]: [0x7f854e003068]    0x7f854d401d70  UIScreen
//        objc[13101]: [0x7f854e003070]    0x7f854d70f8c0  UIWindow
//        objc[13101]: [0x7f854e003078]    0x7f854d401d70  UIScreen
//        objc[13101]: [0x7f854e003080]    0x7f854d401d70  UIScreen
//        objc[13101]: [0x7f854e003088]    0x7f854d5271b0  UITableViewCellSelectedBackground
//        objc[13101]: [0x7f854e003090]    0x7f854d70f8c0  UIWindow
//        objc[13101]: [0x7f854e003098]    0x6000004241a0  __NSSetM
//        objc[13101]: [0x7f854e0030a0]    0x60000001e820  __NSSingleObjectSetI
//        objc[13101]: [0x7f854e0030a8]    0x7f854d5271b0  UITableViewCellSelectedBackground
//        objc[13101]: [0x7f854e0030b0]    0x7f854d70f8c0  UIWindow
//        objc[13101]: [0x7f854e0030b8]    0x7f854d70f8c0  UIWindow
//        objc[13101]: [0x7f854e0030c0]    0x7f854d70f8c0  UIWindow
//        objc[13101]: [0x7f854e0030c8]    0x7f854d401d70  UIScreen
//        objc[13101]: [0x7f854e0030d0]    0x7f854d401d70  UIScreen
//        objc[13101]: [0x7f854e0030d8]    0x7f854d70f8c0  UIWindow
//        objc[13101]: [0x7f854e0030e0]    0x7f854d401d70  UIScreen
//        objc[13101]: [0x7f854e0030e8]    0x7f854d70f8c0  UIWindow
//        objc[13101]: [0x7f854e0030f0]    0x7f854d5271b0  UITableViewCellSelectedBackground
//        objc[13101]: [0x7f854e0030f8]    0x7f854d70f8c0  UIWindow
//        objc[13101]: [0x7f854e003100]    0x7f854d401d70  UIScreen
//        objc[13101]: [0x7f854e003108]    0x600000422340  CALayer
//        objc[13101]: [0x7f854e003110]    0x600000028200  CAContextImpl
//        objc[13101]: [0x7f854e003118]    0x7f854d401d70  UIScreen
//        objc[13101]: [0x7f854e003120]    0x7f854d70f8c0  UIWindow
//        objc[13101]: [0x7f854e003128]    0x7f854d70f8c0  UIWindow
//        objc[13101]: [0x7f854e003130]    0x7f854d401d70  UIScreen
//        objc[13101]: [0x7f854e003138]    0x7f854d401d70  UIScreen
//        objc[13101]: [0x7f854e003140]    0x7f854d70f8c0  UIWindow
//        objc[13101]: [0x7f854e003148]    0x7f854d401d70  UIScreen
//        objc[13101]: [0x7f854e003150]    0x7f854d401d70  UIScreen
//        objc[13101]: [0x7f854e003158]    0x7f854d70f8c0  UIWindow
//        objc[13101]: [0x7f854e003160]    0x7f854d70f8c0  UIWindow
//        objc[13101]: [0x7f854e003168]    0x7f854d401d70  UIScreen
//        objc[13101]: [0x7f854e003170]    0x7f854d70f8c0  UIWindow
//        objc[13101]: [0x7f854e003178]    0x7f854d401d70  UIScreen
//        objc[13101]: [0x7f854e003180]    0x7f854d70f8c0  UIWindow
//        objc[13101]: [0x7f854e003188]    0x7f854d401d70  UIScreen
//        objc[13101]: [0x7f854e003190]    0x7f854d401d70  UIScreen
//        objc[13101]: [0x7f854e003198]    0x7f854d70f8c0  UIWindow
//        objc[13101]: [0x7f854e0031a0]    0x7f854d401d70  UIScreen
//        objc[13101]: [0x7f854e0031a8]    0x7f854d401d70  UIScreen
//        objc[13101]: [0x7f854e0031b0]    0x7f854d70f8c0  UIWindow
//        objc[13101]: [0x7f854e0031b8]    0x600000032780  NSTaggedPointerStringCStringContainer
//        objc[13101]: [0x7f854e0031c0]    0x6000004475c0  __NSArrayI
//        objc[13101]: [0x7f854e0031c8]    0x7f854e873a00  DemoNavigationController
//        objc[13101]: [0x7f854e0031d0]    0x60000023fb00  __NSCFString
//        objc[13101]: [0x7f854e0031d8]    0x604000280cd0  NSBundle
//        objc[13101]: [0x7f854e0031e0]    0x6000002c0e00  UIApplicationSceneSettings
//        objc[13101]: [0x7f854e0031e8]    0x6000000fef00  NSConcretePointerFunctions
//        objc[13101]: [0x7f854e0031f0]    0x7f854d50f330  UIStatusBarWindow
//        objc[13101]: [0x7f854e0031f8]    0x7f854d70f8c0  UIWindow
//        objc[13101]: [0x7f854e003200]    0x7f854d63e450  _UIInteractiveHighlightEffectWindow
//        objc[13101]: [0x7f854e003208]    0x600000135b80  NSConcretePointerArray
//        objc[13101]: [0x7f854e003210]    0x7f854d50f330  UIStatusBarWindow
//        objc[13101]: [0x7f854e003218]    0x7f854d70f8c0  UIWindow
//        objc[13101]: [0x7f854e003220]    0x7f854d63e450  _UIInteractiveHighlightEffectWindow
//        objc[13101]: [0x7f854e003228]    0x60000044c1b0  __NSArrayM
//        objc[13101]: [0x7f854e003230]    0x7f854d51f1b0  ARCAutoReleaseViewController
//        objc[13101]: [0x7f854e003238]    0x7f854d51f1b0  ARCAutoReleaseViewController
//        objc[13101]: ##############
}

//系统类方法-2-崩溃
- (void)systemClassMethodStudyTwo {
    id __unsafe_unretained target = nil;
    {
        //这里返回的对象直接是自己持有,更没有注册到自动释放池中了
        id temp = [[NSMutableArray alloc]init];
        NSLog(@"temp-RetainCount = %lu", _objc_rootRetainCount(temp));
        [temp addObject:@"obj"];
        target = temp;
        NSLog(@"temp = %@", temp);
    }//超出作用域,temp所指对象就被销毁,target还指向一段被回收的内存,所以崩溃
    NSLog(@"target = %@",target);
    
    //以上代码等价于以下代码：
    {
        //id obj = objc_msgSend(NSObject, @selector(alloc));
        //objc_msgSend(obj, @selector(init));
        //...
        //objc_release(obj);
    }
    
    // 同上
}

//系统类方法-3-不崩溃
- (void)systemClassMethodStudyThree {
    id __unsafe_unretained target = nil;
    {
        @autoreleasepool {//手动添加自动释放池,会崩溃
        //这里对象已经被加入到自动释放池 ([[NSMutableArray alloc]init];/[NSMutableArray array]不会被加入到自动释放池，所以依旧为1 - 其实也和外部是否有强引用有关，后面会讲到)
        id temp = [[NSMutableArray alloc]init];//[NSMutableArray arrayWithObjects:@"obj",nil];
        NSLog(@"temp-RetainCount = %lu", _objc_rootRetainCount(temp));
        target = temp;
        
        //自动释放池+temp强引用=2
        NSLog(@"temp-RetainCount = %lu", _objc_rootRetainCount(temp));
        NSLog(@"temp = %@", temp);
        }
    }//因为在自动释放池中,所以这里对象还没有被释放,会等到下一次时间循环时释放自动释放池
    NSLog(@"target = %@", target);
    
}

//自定义类方法研究-1-不会崩溃
- (void)customizeClassMethodStudyOne {
    id __unsafe_unretained target = nil;
    {
        //对象被放到了自动释放池中
        id temp = [[self class] Object];
        [temp addObject:@"obj"];
        
        target = temp;
        NSLog(@"temp.RetainCount = %lu", _objc_rootRetainCount(temp));
        NSLog(@"temp = %@", temp);
//        [[self class] Object];这里实质是调用分类的下面方法，通过这种方式调用-对象被放到了自动释放池中
//        + (id)Object {
//            return [NSMutableArray array];
//        }
    }
    NSLog(@"target = %@", target);

    // 打印结果如下 -
//    2018-05-10 16:08:47.545094+0800 内存管理实例[13721:1055261] temp.RetainCount = 2
//    2018-05-10 16:08:47.545546+0800 内存管理实例[13721:1055261] temp = (
//                                                                  obj
//                                                                  )
//    2018-05-10 16:08:47.546175+0800 内存管理实例[13721:1055261] target = (
//                                                                    obj
//                                                                    )
}

//自定义类方法研究-2-崩溃
- (void)customizeClassMethodStudyTwo {
    id __unsafe_unretained target = nil;
    {
        //这里对象没有出现在自动释放池中
        id temp = [[self class] Objects];
        [temp addObject:@"obj"];
        
        target = temp;
        NSLog(@"temp.RetainCount = %lu", _objc_rootRetainCount(temp));
        NSLog(@"temp = %@", temp);
//        [[self class] Objects];这里实质是调用分类的下面方法，通过这种方式调用-对象被放到了自动释放池中
//        + (id)Objects {
//            NSMutableArray *marr = [NSMutableArray array];//崩溃
//            return marr;
//        }
//        通过[NSMutableArray array]和[[NSMutableArray alloc]init]外面如果有强引用指针,则不加入自动释放池 如：NSMutableArray *marr = [NSMutableArray array];
    }
    NSLog(@"target = %@", target);
    
    // 打印结果如下 -
//        2018-05-10 16:27:14.918202+0800 内存管理实例[14184:1119706] temp.RetainCount = 1
//    2018-05-10 16:27:14.918530+0800 内存管理实例[14184:1119706] temp = (
//                                                                  obj
//                                                                  )
}

//自定义类方法研究-3-崩溃
- (void)customizeClassMethodStudyThree {
    id __unsafe_unretained target = nil;
    {
        id temp = [[self class] Objectss];
        [temp addObject:@"obj"];
        
        target = temp;
        NSLog(@"temp.RetainCount = %lu", _objc_rootRetainCount(temp));
        NSLog(@"temp = %@", temp);
    }
    NSLog(@"target = %@", target);
    // 同上讲述
    
    // 打印结果如下 -
//    2018-05-10 16:32:15.200624+0800 内存管理实例[14274:1143940] temp.RetainCount = 1
//    2018-05-10 16:32:15.201101+0800 内存管理实例[14274:1143940] temp = (
//                                                                  obj
//                                                                  )

}

//自定义类方法研究-4-崩溃
- (void)customizeClassMethodStudyFour {
    id __unsafe_unretained target = nil;
    {
        id temp = [[self class] Objectsss];
        [temp addObject:@"obj"];
        
        target = temp;
        NSLog(@"temp.RetainCount = %lu", _objc_rootRetainCount(temp));
        NSLog(@"temp = %@", temp);
    }
    NSLog(@"target = %@", target);
    // 同上讲述 - 例二所述
    
    // 打印结果如下 -
//    2018-05-10 16:33:18.978652+0800 内存管理实例[14308:1149295] temp.RetainCount = 1
//    2018-05-10 16:33:18.978978+0800 内存管理实例[14308:1149295] temp = (
//                                                                  obj
//                                                                  )
}

//自定义类方法研究-5-崩溃
- (void)customizeClassMethodStudyFive {
    id __unsafe_unretained target = nil;
    {
        id temp = [[self class] copyObject];
        NSLog(@"temp.RetainCount = %lu", _objc_rootRetainCount(temp));
        [temp addObject:@"obj"];
        
        target = temp;
        NSLog(@"temp.RetainCount = %lu", _objc_rootRetainCount(temp));
        NSLog(@"temp = %@", temp);
    }
    NSLog(@"target = %@", target);
    // 以alloc、new、copy、mutableCopy开头的方法,返回的只有这一种情况
    
    // 打印结果如下 -
//    2018-05-10 16:36:16.384642+0800 内存管理实例[14370:1161961] temp.RetainCount = 1
//    2018-05-10 16:36:16.384956+0800 内存管理实例[14370:1161961] temp = (
//                                                                  obj
//                                                                  )
}

//自定义类方法研究-6-崩溃
- (void)customizeClassMethodStudySix {
    id __unsafe_unretained target = nil;
    {
        id temp = [[self class] copyObjects];
        [temp addObject:@"obj"];
        
        target = temp;
        NSLog(@"temp.RetainCount = %lu",_objc_rootRetainCount(temp));
        NSLog(@"temp = %@", temp);
    }
    NSLog(@"target = %@", target);
    
    // 同上
    
    // 打印结果如下 -
//    2018-05-10 16:48:19.701094+0800 内存管理实例[14708:1217917] temp.RetainCount = 1
//    2018-05-10 16:48:19.701344+0800 内存管理实例[14708:1217917] temp = (
//                                                                  obj
//                                                                  )
}

//自定义类方法研究-7-崩溃
- (void)customizeClassMethodStudySeven {
    id __unsafe_unretained target = nil;
    {
        id temp = [[self class] copyObjectss];
        [temp addObject:@"obj"];
        
        target = temp;
        NSLog(@"temp.RetainCount = %lu",_objc_rootRetainCount(temp));
        NSLog(@"temp = %@", temp);
    }
    NSLog(@"target = %@", target);
    
    // 同上
    
    // 打印结果如下 -
//    2018-05-10 16:49:03.689696+0800 内存管理实例[14737:1221407] temp.RetainCount = 1
//    2018-05-10 16:49:03.692696+0800 内存管理实例[14737:1221407] temp = (
//                                                                  obj
//                                                                  )
}

//自定义类方法研究-8-崩溃
- (void)customizeClassMethodStudyEight {
    id __unsafe_unretained target = nil;
    {
        id temp = [[self class] copyObjectsss];
        [temp addObject:@"obj"];
        
        target = temp;
        NSLog(@"temp.RetainCount = %lu",_objc_rootRetainCount(temp));
        NSLog(@"temp = %@", temp);
    }
    NSLog(@"target = %@", target);
    
// 同上
    
// 打印结果如下 -
//    2018-05-10 16:49:03.689696+0800 内存管理实例[14737:1221407] temp.RetainCount = 1
//    2018-05-10 16:49:03.692696+0800 内存管理实例[14737:1221407] temp = (
//                                                                  obj
//
}


@end
