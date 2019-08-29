//
//  MRCAutoReleaseViewController.m
//  内存管理实例
//
//  Created by 汪俊 on 2018/4/28.
//  Copyright © 2018年 汪俊. All rights reserved.
//

#import "MRCAutoReleaseViewController.h"
#import "Person.h"
#import "Animal.h"


@implementation MRCAutoReleaseViewController

#pragma mark - life style
//当前是MRC环境!!!
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self autoReleaseStudy];
//    [self autoReleaseMany];
    [self autoReleaseClass];
}

#pragma mark - private
//主动使用autorelease
- (void)autoReleaseStudy {
    //因为自动释放池释放时机是当前runloop结束,不好控制,所以这里自己创建自动释放池
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    Person *person = [[Person alloc]init];
    NSLog(@"personCount-1 = %ld",(long)CFGetRetainCount((__bridge CFTypeRef)(person)));
    //调用这个,对象引用计数为0,立马释放
    //[person release];
    
    //调用这个,发现引用计数没有发生改变,它只是提供一种延时释放机制
    [person autorelease];
    NSLog(@"personCount-2 = %ld",(long)CFGetRetainCount((__bridge CFTypeRef)(person)));
    
    //当前自动释放池中含有Person对象
    _objc_autoreleasePoolPrint();
    
//    下面为池子内容，可以看出有person
//    objc[14863]: ##############
//    objc[14863]: AUTORELEASE POOLS for thread 0x10aec8340
//        objc[14863]: 55 releases pending.
//        objc[14863]: [0x7ffe43003000]  ................  PAGE  (hot) (cold)
//        objc[14863]: [0x7ffe43003038]  ################  POOL 0x7ffe43003038
//        objc[14863]: [0x7ffe43003040]    0x60400002bf80  __NSCFString
//        objc[14863]: [0x7ffe43003048]  ################  POOL 0x7ffe43003048
//        objc[14863]: [0x7ffe43003050]    0x7ffe4251ff80  UITableViewCellSelectedBackground
//        objc[14863]: [0x7ffe43003058]    0x7ffe4251ff80  UITableViewCellSelectedBackground
//        objc[14863]: [0x7ffe43003060]    0x7ffe42616490  UIWindow
//        objc[14863]: [0x7ffe43003068]    0x600000220d00  __NSSetM
//        objc[14863]: [0x7ffe43003070]    0x600000002c20  __NSSingleObjectSetI
//        objc[14863]: [0x7ffe43003078]    0x7ffe4251ff80  UITableViewCellSelectedBackground
//        objc[14863]: [0x7ffe43003080]    0x7ffe42616490  UIWindow
//        objc[14863]: [0x7ffe43003088]    0x7ffe42616490  UIWindow
//        objc[14863]: [0x7ffe43003090]    0x7ffe42616490  UIWindow
//        objc[14863]: [0x7ffe43003098]    0x7ffe42702b20  UIScreen
//        objc[14863]: [0x7ffe430030a0]    0x7ffe42702b20  UIScreen
//        objc[14863]: [0x7ffe430030a8]    0x7ffe42616490  UIWindow
//        objc[14863]: [0x7ffe430030b0]    0x7ffe42702b20  UIScreen
//        objc[14863]: [0x7ffe430030b8]    0x7ffe42616490  UIWindow
//        objc[14863]: [0x7ffe430030c0]    0x7ffe4251ff80  UITableViewCellSelectedBackground
//        objc[14863]: [0x7ffe430030c8]    0x7ffe42616490  UIWindow
//        objc[14863]: [0x7ffe430030d0]    0x7ffe42702b20  UIScreen
//        objc[14863]: [0x7ffe430030d8]    0x6000002255e0  CALayer
//        objc[14863]: [0x7ffe430030e0]    0x6000000399c0  CAContextImpl
//        objc[14863]: [0x7ffe430030e8]    0x7ffe42702b20  UIScreen
//        objc[14863]: [0x7ffe430030f0]    0x7ffe42616490  UIWindow
//        objc[14863]: [0x7ffe430030f8]    0x7ffe42616490  UIWindow
//        objc[14863]: [0x7ffe43003100]    0x7ffe42702b20  UIScreen
//        objc[14863]: [0x7ffe43003108]    0x7ffe42702b20  UIScreen
//        objc[14863]: [0x7ffe43003110]    0x7ffe42616490  UIWindow
//        objc[14863]: [0x7ffe43003118]    0x7ffe42702b20  UIScreen
//        objc[14863]: [0x7ffe43003120]    0x7ffe42702b20  UIScreen
//        objc[14863]: [0x7ffe43003128]    0x7ffe42616490  UIWindow
//        objc[14863]: [0x7ffe43003130]    0x7ffe42616490  UIWindow
//        objc[14863]: [0x7ffe43003138]    0x7ffe42702b20  UIScreen
//        objc[14863]: [0x7ffe43003140]    0x7ffe42616490  UIWindow
//        objc[14863]: [0x7ffe43003148]    0x7ffe42702b20  UIScreen
//        objc[14863]: [0x7ffe43003150]    0x7ffe42616490  UIWindow
//        objc[14863]: [0x7ffe43003158]    0x60400002c340  NSTaggedPointerStringCStringContainer
//        objc[14863]: [0x7ffe43003160]    0x604000254400  __NSArrayI
//        objc[14863]: [0x7ffe43003168]    0x600000226260  __NSCFString
//        objc[14863]: [0x7ffe43003170]    0x604000288430  NSBundle
//        objc[14863]: [0x7ffe43003178]    0x6040000d2d00  UIApplicationSceneSettings
//        objc[14863]: [0x7ffe43003180]    0x6000000f0e00  NSConcretePointerFunctions
//        objc[14863]: [0x7ffe43003188]    0x7ffe42409020  UIStatusBarWindow
//        objc[14863]: [0x7ffe43003190]    0x7ffe42616490  UIWindow
//        objc[14863]: [0x7ffe43003198]    0x7ffe42706660  _UIInteractiveHighlightEffectWindow
//        objc[14863]: [0x7ffe430031a0]    0x60000013df60  NSConcretePointerArray
//        objc[14863]: [0x7ffe430031a8]    0x7ffe42409020  UIStatusBarWindow
//        objc[14863]: [0x7ffe430031b0]    0x7ffe42616490  UIWindow
//        objc[14863]: [0x7ffe430031b8]    0x7ffe42706660  _UIInteractiveHighlightEffectWindow
//        objc[14863]: [0x7ffe430031c0]    0x600000259050  __NSArrayM
//        objc[14863]: [0x7ffe430031c8]    0x7ffe4272f390  MRCAutoReleaseViewController
//        objc[14863]: [0x7ffe430031d0]    0x7ffe4272f390  MRCAutoReleaseViewController
//        objc[14863]: [0x7ffe430031d8]    0x7ffe4272fa00  UIView
//        objc[14863]: [0x7ffe430031e0]  ################  POOL 0x7ffe430031e0
//        objc[14863]: [0x7ffe430031e8]    0x600000002b80  Person
//        objc[14863]: ##############
    
    [pool release];
    
    //当前自动释放池中不包含Person对象
    _objc_autoreleasePoolPrint();

//    下面为池子内容，可以看出，没有person
//    objc[14863]: ##############
//    objc[14863]: AUTORELEASE POOLS for thread 0x10aec8340
//        objc[14863]: 53 releases pending.
//        objc[14863]: [0x7ffe43003000]  ................  PAGE  (hot) (cold)
//        objc[14863]: [0x7ffe43003038]  ################  POOL 0x7ffe43003038
//        objc[14863]: [0x7ffe43003040]    0x60400002bf80  __NSCFString
//        objc[14863]: [0x7ffe43003048]  ################  POOL 0x7ffe43003048
//        objc[14863]: [0x7ffe43003050]    0x7ffe4251ff80  UITableViewCellSelectedBackground
//        objc[14863]: [0x7ffe43003058]    0x7ffe4251ff80  UITableViewCellSelectedBackground
//        objc[14863]: [0x7ffe43003060]    0x7ffe42616490  UIWindow
//        objc[14863]: [0x7ffe43003068]    0x600000220d00  __NSSetM
//        objc[14863]: [0x7ffe43003070]    0x600000002c20  __NSSingleObjectSetI
//        objc[14863]: [0x7ffe43003078]    0x7ffe4251ff80  UITableViewCellSelectedBackground
//        objc[14863]: [0x7ffe43003080]    0x7ffe42616490  UIWindow
//        objc[14863]: [0x7ffe43003088]    0x7ffe42616490  UIWindow
//        objc[14863]: [0x7ffe43003090]    0x7ffe42616490  UIWindow
//        objc[14863]: [0x7ffe43003098]    0x7ffe42702b20  UIScreen
//        objc[14863]: [0x7ffe430030a0]    0x7ffe42702b20  UIScreen
//        objc[14863]: [0x7ffe430030a8]    0x7ffe42616490  UIWindow
//        objc[14863]: [0x7ffe430030b0]    0x7ffe42702b20  UIScreen
//        objc[14863]: [0x7ffe430030b8]    0x7ffe42616490  UIWindow
//        objc[14863]: [0x7ffe430030c0]    0x7ffe4251ff80  UITableViewCellSelectedBackground
//        objc[14863]: [0x7ffe430030c8]    0x7ffe42616490  UIWindow
//        objc[14863]: [0x7ffe430030d0]    0x7ffe42702b20  UIScreen
//        objc[14863]: [0x7ffe430030d8]    0x6000002255e0  CALayer
//        objc[14863]: [0x7ffe430030e0]    0x6000000399c0  CAContextImpl
//        objc[14863]: [0x7ffe430030e8]    0x7ffe42702b20  UIScreen
//        objc[14863]: [0x7ffe430030f0]    0x7ffe42616490  UIWindow
//        objc[14863]: [0x7ffe430030f8]    0x7ffe42616490  UIWindow
//        objc[14863]: [0x7ffe43003100]    0x7ffe42702b20  UIScreen
//        objc[14863]: [0x7ffe43003108]    0x7ffe42702b20  UIScreen
//        objc[14863]: [0x7ffe43003110]    0x7ffe42616490  UIWindow
//        objc[14863]: [0x7ffe43003118]    0x7ffe42702b20  UIScreen
//        objc[14863]: [0x7ffe43003120]    0x7ffe42702b20  UIScreen
//        objc[14863]: [0x7ffe43003128]    0x7ffe42616490  UIWindow
//        objc[14863]: [0x7ffe43003130]    0x7ffe42616490  UIWindow
//        objc[14863]: [0x7ffe43003138]    0x7ffe42702b20  UIScreen
//        objc[14863]: [0x7ffe43003140]    0x7ffe42616490  UIWindow
//        objc[14863]: [0x7ffe43003148]    0x7ffe42702b20  UIScreen
//        objc[14863]: [0x7ffe43003150]    0x7ffe42616490  UIWindow
//        objc[14863]: [0x7ffe43003158]    0x60400002c340  NSTaggedPointerStringCStringContainer
//        objc[14863]: [0x7ffe43003160]    0x604000254400  __NSArrayI
//        objc[14863]: [0x7ffe43003168]    0x600000226260  __NSCFString
//        objc[14863]: [0x7ffe43003170]    0x604000288430  NSBundle
//        objc[14863]: [0x7ffe43003178]    0x6040000d2d00  UIApplicationSceneSettings
//        objc[14863]: [0x7ffe43003180]    0x6000000f0e00  NSConcretePointerFunctions
//        objc[14863]: [0x7ffe43003188]    0x7ffe42409020  UIStatusBarWindow
//        objc[14863]: [0x7ffe43003190]    0x7ffe42616490  UIWindow
//        objc[14863]: [0x7ffe43003198]    0x7ffe42706660  _UIInteractiveHighlightEffectWindow
//        objc[14863]: [0x7ffe430031a0]    0x60000013df60  NSConcretePointerArray
//        objc[14863]: [0x7ffe430031a8]    0x7ffe42409020  UIStatusBarWindow
//        objc[14863]: [0x7ffe430031b0]    0x7ffe42616490  UIWindow
//        objc[14863]: [0x7ffe430031b8]    0x7ffe42706660  _UIInteractiveHighlightEffectWindow
//        objc[14863]: [0x7ffe430031c0]    0x600000259050  __NSArrayM
//        objc[14863]: [0x7ffe430031c8]    0x7ffe4272f390  MRCAutoReleaseViewController
//        objc[14863]: [0x7ffe430031d0]    0x7ffe4272f390  MRCAutoReleaseViewController
//        objc[14863]: [0x7ffe430031d8]    0x7ffe4272fa00  UIView
//        objc[14863]: ##############
}

//多次使用autorelease
- (void)autoReleaseMany {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    Person *person = [[Person alloc]init];
    [person autorelease];
    [person autorelease];
    
    //当前自动释放池中含有Person对象,是两个相同地址的对象<同一个对象>
    _objc_autoreleasePoolPrint();

//    很明显看出池子里有两个person
//    objc[14935]: ##############
//    objc[14935]: AUTORELEASE POOLS for thread 0x10bfa0340
//        objc[14935]: 57 releases pending.
//        objc[14935]: [0x7fee72003000]  ................  PAGE  (hot) (cold)
//        objc[14935]: [0x7fee72003038]  ################  POOL 0x7fee72003038
//        objc[14935]: [0x7fee72003040]    0x604000031060  __NSCFString
//        objc[14935]: [0x7fee72003048]  ################  POOL 0x7fee72003048
//        objc[14935]: [0x7fee72003050]    0x7fee71f3bef0  UITableViewCellSelectedBackground
//        objc[14935]: [0x7fee72003058]    0x7fee71f3bef0  UITableViewCellSelectedBackground
//        objc[14935]: [0x7fee72003060]    0x7fee71f04550  UIWindow
//        objc[14935]: [0x7fee72003068]    0x6000002376e0  __NSSetM
//        objc[14935]: [0x7fee72003070]    0x60000000c990  __NSSingleObjectSetI
//        objc[14935]: [0x7fee72003078]    0x7fee71f3bef0  UITableViewCellSelectedBackground
//        objc[14935]: [0x7fee72003080]    0x7fee71f04550  UIWindow
//        objc[14935]: [0x7fee72003088]    0x7fee71f04550  UIWindow
//        objc[14935]: [0x7fee72003090]    0x7fee71f04550  UIWindow
//        objc[14935]: [0x7fee72003098]    0x7fee71e00e20  UIScreen
//        objc[14935]: [0x7fee720030a0]    0x7fee71e00e20  UIScreen
//        objc[14935]: [0x7fee720030a8]    0x7fee71f04550  UIWindow
//        objc[14935]: [0x7fee720030b0]    0x7fee71e00e20  UIScreen
//        objc[14935]: [0x7fee720030b8]    0x7fee71f04550  UIWindow
//        objc[14935]: [0x7fee720030c0]    0x7fee71f3bef0  UITableViewCellSelectedBackground
//        objc[14935]: [0x7fee720030c8]    0x7fee71f04550  UIWindow
//        objc[14935]: [0x7fee720030d0]    0x7fee71e00e20  UIScreen
//        objc[14935]: [0x7fee720030d8]    0x60000023be20  CALayer
//        objc[14935]: [0x7fee720030e0]    0x600000231600  CAContextImpl
//        objc[14935]: [0x7fee720030e8]    0x7fee71e00e20  UIScreen
//        objc[14935]: [0x7fee720030f0]    0x7fee71f04550  UIWindow
//        objc[14935]: [0x7fee720030f8]    0x7fee71f04550  UIWindow
//        objc[14935]: [0x7fee72003100]    0x7fee71e00e20  UIScreen
//        objc[14935]: [0x7fee72003108]    0x7fee71e00e20  UIScreen
//        objc[14935]: [0x7fee72003110]    0x7fee71f04550  UIWindow
//        objc[14935]: [0x7fee72003118]    0x7fee71e00e20  UIScreen
//        objc[14935]: [0x7fee72003120]    0x7fee71e00e20  UIScreen
//        objc[14935]: [0x7fee72003128]    0x7fee71f04550  UIWindow
//        objc[14935]: [0x7fee72003130]    0x7fee71f04550  UIWindow
//        objc[14935]: [0x7fee72003138]    0x7fee71e00e20  UIScreen
//        objc[14935]: [0x7fee72003140]    0x7fee71f04550  UIWindow
//        objc[14935]: [0x7fee72003148]    0x7fee71e00e20  UIScreen
//        objc[14935]: [0x7fee72003150]    0x7fee71f04550  UIWindow
//        objc[14935]: [0x7fee72003158]    0x6000000270c0  NSTaggedPointerStringCStringContainer
//        objc[14935]: [0x7fee72003160]    0x60400044b400  __NSArrayI
//        objc[14935]: [0x7fee72003168]    0x7fee71c36610  DemoListTableVC
//        objc[14935]: [0x7fee72003170]    0x6000002387e0  __NSCFString
//        objc[14935]: [0x7fee72003178]    0x604000288200  NSBundle
//        objc[14935]: [0x7fee72003180]    0x6000002c2290  UIApplicationSceneSettings
//        objc[14935]: [0x7fee72003188]    0x6000000eef80  NSConcretePointerFunctions
//        objc[14935]: [0x7fee72003190]    0x7fee71f0a600  UIStatusBarWindow
//        objc[14935]: [0x7fee72003198]    0x7fee71f04550  UIWindow
//        objc[14935]: [0x7fee720031a0]    0x7fee71d1a370  _UIInteractiveHighlightEffectWindow
//        objc[14935]: [0x7fee720031a8]    0x600000138920  NSConcretePointerArray
//        objc[14935]: [0x7fee720031b0]    0x7fee71f0a600  UIStatusBarWindow
//        objc[14935]: [0x7fee720031b8]    0x7fee71f04550  UIWindow
//        objc[14935]: [0x7fee720031c0]    0x7fee71d1a370  _UIInteractiveHighlightEffectWindow
//        objc[14935]: [0x7fee720031c8]    0x600000259290  __NSArrayM
//        objc[14935]: [0x7fee720031d0]    0x7fee71f39b00  MRCAutoReleaseViewController
//        objc[14935]: [0x7fee720031d8]    0x7fee71f39b00  MRCAutoReleaseViewController
//        objc[14935]: [0x7fee720031e0]    0x7fee71f13310  UIView
//        objc[14935]: [0x7fee720031e8]  ################  POOL 0x7fee720031e8
//        objc[14935]: [0x7fee720031f0]    0x60000000c710  Person
//        objc[14935]: [0x7fee720031f8]    0x60000000c710  Person
//        objc[14935]: ##############
    
    //这里会崩溃,因为person两次被加入自动释放池;
    //当自动释放池被销毁时,会向对象发送两次release消息;
    //但是引用计数开始为1,减两次为-1,所以会崩溃
    [pool release];
}

//类方法研究autorelease
- (void)autoReleaseClass {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    // it的引用计数为1
    Animal *it = [Animal productItem];
    // 接下来可以调用it的方法
    NSLog(@"it.retainCount：%ld" , it.retainCount);
    // ...
    // 创建一个FKUser对象，并将它添加到自动释放池
    Person *user = [[[Person alloc] init] autorelease];
    // 接下来可以调用user的方法
    NSLog(@"user.retainCount：%ld" , user.retainCount);
    // ...
    // 系统将因为池的引用计数变为0而回收自动释放池，
    // 回收自动释放池时会调用池中所有对象的release方法
    [pool release];
}

//总结：
//1、autorelease:该方法不会改变对象的引用计数,只是将该对象添加到自动释放池中
//2、自动释放池销毁时机:一次runloop结束||作用域超出{}||执行[pool release]
//3、执行几次autorelease,自动释放池销毁时,会向对象发送几次release消息
//4、release和drain区别:release会导致自动释放池自身的引用计数变为0,从而让系统回收NSAutoreleasePool;而drain只是回收释放池中的所有对象
//5、只要方法不是以alloc、new、copy、mutableCopy开头的,系统会默认创建自动释放的对象
//6、自动释放池中的对象是临时对象,要想保住这个临时对象,需要手动调用retain或者将临时对象赋值给retain、strong、copy指示符修饰的属性
//7、放在自动释放池中对象,会被延迟释放;此时可以理解为引用计数为1
//   当自动释放池被销毁时,会向里面的对象发送一条release信息
@end
