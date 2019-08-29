//
//  MemoryManagementRulesController.m
//  内存管理实例
//
//  Created by 汪俊 on 2018/4/28.
//  Copyright © 2018年 汪俊. All rights reserved.
//

#import "MemoryManagementRulesController.h"


@interface MemoryManagementRulesController ()

@end

@implementation MemoryManagementRulesController

//当前要在MRC环境下执行！！！
/*
 ARC下获取引用计数
 1、使用KVC
 [obj valueForKey:@"retainCount"]
 
 2、使用私有API--不太建议使用，打印结果有问题
 OBJC_EXTERN int _objc_rootRetainCount(id);
 _objc_rootRetainCount(obj)
 
 3、使用CFGetRetainCount--建议使用
 CFGetRetainCount((__bridge CFTypeRef)(obj))
 */

/*
 查看反编译代码
 1、将代码转化为汇编指令(学习内存管理很有用)!!!
 clang -S -fobjc-arc main.m
 
 2、在终端使用Clang命令 编译（相比于Xcode运行，可以单独的编译文件并运行）
 clang -fobjc-arc -framework Foundation AAAA.m -o BBBB
 
 3、Clang重写m文件为cpp文件(重点说下，在学习Runtime时候很有用，可以逆向观察学习)!!!
 clang -rewrite-objc main.m
 */
#pragma mark - life style
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //四条法则验证
    [self testRule];
}

#pragma mark - private

/*
 * 自己生成的对象，自己持有
 * 非自己生成的对象，自己也能持有 --- MRC中通过retain实现；ARC中因为__strong缘故，直接强引用
 * 不再需要自己持有的对象时释放
 * 非自己持有的对象无法释放      --- MRC中无法调用release，否则会崩溃；ARC中不会调用release
 *
 * 以上是否持有关系到自己有没有权利释放。
 */
- (void)testRule {
    //1、生成(alloc、new、copy、mutablecopy等)并持有对象、引用计数加1
    id objOne = [[NSObject alloc]init];
    NSLog(@"retain count-1 = %ld" ,CFGetRetainCount((__bridge CFTypeRef)(objOne)));
    
    //2、非生成(除以上方法之外)、自己持有(通过retain)
    id objTwo = [NSMutableArray array];
    //这里引用计数为1
    //可以理解这个对象已经在自动缓存池中存有，但是不是objTwo所持有!!!
    NSLog(@"retain count-2 = %ld" ,CFGetRetainCount((__bridge CFTypeRef)(objTwo)));
    [objTwo retain];
    NSLog(@"retain count-2 = %ld" ,CFGetRetainCount((__bridge CFTypeRef)(objTwo)));
    
    //3、不需要自己持有的对象时释放
    id objThree = [[NSObject alloc]init];
    NSLog(@"retain count-3 = %ld" ,CFGetRetainCount((__bridge CFTypeRef)(objThree)));
    [objThree release];
    //进行以下操作会崩溃、因为对象释放
    //NSLog(@"retain count-3 = %ld",CFGetRetainCount((__bridge CFTypeRef)(objThree)));
    
    //4、非自己生成并持有的对象，若用retain变为自己持有，也可以用release释放
    id objFour = [NSMutableArray array];
    //这里引用计数为1
    //可以理解这个对象已经在自动缓存池中存有，但是不是objFour所持有!!!
    NSLog(@"retain count-4 = %ld",CFGetRetainCount((__bridge CFTypeRef)(objFour)));
    [objFour retain];
    NSLog(@"retain count-4 = %ld",CFGetRetainCount((__bridge CFTypeRef)(objFour)));
    [objFour release];
    //此时引用计数还是1，而不是0；可以理解为对象还放在缓存池中，不由当前对象释放。
    NSLog(@"retain count-4 = %ld",CFGetRetainCount((__bridge CFTypeRef)(objFour)));
    
    //5、直接释放自己没有持有的对象，会造成崩溃
    id objFive = [NSMutableArray array];
    NSLog(@"retain count-5 = %ld",CFGetRetainCount((__bridge CFTypeRef)(objFive)));
    //不能直接进行以下操作，会崩溃
    //[objFive release];
}

#pragma mark - getters & setters
//模仿生成并持有对象的过程
- (id)allocObject {
    id obj = [[NSObject alloc]init];
    return obj;
}

//模仿对象存在，但自己不持有对象的过程
- (id)object {
    id obj = [[NSObject alloc]init];
    //因为加入了autorelease
    //autorelease:使对象在超出指定的生存范围时，能够自动并正确地释放(调用release)
    [obj autorelease];//obj注册到autoreleasepool中，pool结束时自动调用release
    return obj;
}

// 总结：
// 1、调用alloc或是retain,引用计数值加1
// 2、调用release后,引用计数值减1
// 3、引用计数值为0时,调用dealloc方法废弃对象。
// 4、ARC和MRC下都可以使用dealloc方法,只不过是ARC不能显示调用[super dealloc]
//    MRC必须将[super dealloc]放在最后,如果必须调用的话
// 5、放在自动释放池中对象,会被延迟释放;此时可以理解为引用计数为1
//    当自动释放池被销毁时,会向里面的对象发送一条release信息
// 6、某个对象使用多少次autorelease,自动释放池被销毁时,就会向某个对象发送多少次release


@end
