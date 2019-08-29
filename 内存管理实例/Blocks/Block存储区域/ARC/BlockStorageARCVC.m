//
//  BlockStorageARCVC.m
//  内存管理实例
//
//  Created by 汪俊 on 2018/5/7.
//  Copyright © 2018年 汪俊. All rights reserved.
//

#import "BlockStorageARCVC.h"

//Stack
void(^BlockStackOne_ARC)(id);
void(^BlockStackTwo_ARC)(id);

typedef void(^BlockStackThree_ARC)(id);
BlockStackThree_ARC blockThreeARC;

//Global
void(^BlockGlobalOne_ARC)(void) = ^{ NSLog(@"Global Block");};

//Malloc
void(^BlockMallocOne_ARC)(id);
void(^BlockMallocTwo_ARC)(void);

typedef void (^BlockMallocThree_ARC)(void);
typedef int (^BlockMallocFour_ARC)(int);
BlockMallocFour_ARC blockFourARC;

//test
void(^BlockTestARC)(void);

@interface BlockStorageARCVC ()
{
    BlockMallocThree_ARC blockThreeTestARC;
}

@property (nonatomic, strong) NSArray *array;

@end

@implementation BlockStorageARCVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //Stack
//    [self testBlockMRCOne];//----ARC变成Malloc
//    [self testBlockMRCFive];//----ARC变成Malloc
//    [self testBlockMRCSeven];//----ARC变成Malloc

//    2、什么是栈Block <在ARC环境下,不存在栈Block!!!,但是如果block被当成参数,又被返回,在Block>
//    见例12 testBlockMRCTwelve
//    a、block语法的表达式在函数内局部定义,类似于局部变量
//    b、block语法的表达式中使用截获的自动变量时


    //Global
//    [self testBlockMRCThree];
//    [self testBlockMRCFour];
//    [self testBlockMRCTen];
//    1、什么是全局Block
//    a、定义全局变量的地方有block语法时
//    b、block语法的表达式中没有使用应截获的自动变量时
//    c、block语法赋值给成语变量

    //Malloc
//    [self testBlockMRCTwo];
//    [self testBlockMRCSix];
//    [self testBlockMRCEight];
//    [self testBlockMRCNine];
    
//    即使不主动使用copy,默认也是在堆上
    
    //system
//    [self testBlockMRCEleven];
    
    //test
    [self testBlockMRCTwelve];
}

#pragma mark - test1-Stack
- (void)testBlockMRCOne {
    NSInteger i = 10;
    //打断点可以发现,这里是NSMallocBlock,不会❌;
    //这里变量虽然在堆上,但是仍然不能赋值
    BlockStackOne_ARC = ^(id obj){
        NSLog(@"%ld", i);
        //i = 0;
    };
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //这里不用copy,block在堆上
    
//    BlockStackOne_ARC([[NSObject alloc]init]);
    BlockMallocOne_ARC([[NSObject alloc]init]);
}

#pragma mark - test2-Malloc
- (void)testBlockMRCTwo {
    NSInteger i = 10;
    //打断点可以发现,这里是NSMallocBlock isa指针地址：0x000000010ed4b170 __NSMallocBlock__
    BlockMallocOne_ARC = ^(id obj){
        NSLog(@"%ld", i);
    };
}

#pragma mark - test3-Global
- (void)testBlockMRCThree {
    //这里是NWJlobalBlock
    BlockGlobalOne_ARC();
}

#pragma mark - test4-Global
- (void)testBlockMRCFour {
    //在代码不截获自动变量时，生成的block也是在全局区
    //这里是NWJlobalBlock
    
    int(^block)(int count) = ^(int count) {
        return count;
    };
    
    NSLog(@"block(2) = %d",block(2));
}

#pragma mark - test5-Stack
- (void)testBlockMRCFive {
    //在代码不截获自动变量时，生成的block也是在全局区
    // 什么是全局区？全局区（静态区）（static）—，全局变量和静态变量的存储是放在一块的，初始化的
    // 全局变量和静态变量在一块区域， 未初始化的全局变量和未初始化的静态变量在相邻的另一块区域。 - 程序结束后由系统释放。
    //这里虽然截获了自动变量,但是在NSMallocBlock
    
    int tempValue = 10;
    
    int(^block)(int count) = ^(int count) {
        return count * tempValue;
    };
    
    NSLog(@"block(2) = %d",block(2));
}

#pragma mark - test6-Malloc
- (void)testBlockMRCSix {
    __block NSInteger i = 10;
    //    BlockMallocTwo_ARC = [^{
    //        ++i;
    //    } copy];
    
    //这里即使不用copy,也是放在堆上
    BlockMallocTwo_ARC = ^{
        ++i;
    };
    
    //11
    ++i;//++(i->__forwarding->i);
    
    //12
    BlockMallocTwo_ARC();
    
    NSLog(@"i = %ld", i);
}

#pragma mark - test7-Stack
- (void)testBlockMRCSeven {
    [self funBlock];
    //这里不会崩溃,因为block在Malloc上
    blockThreeARC([[NSObject alloc] init]);
    blockThreeARC([[NSObject alloc] init]);
    blockThreeARC([[NSObject alloc] init]);
}

- (void)funBlock {
    NSMutableArray *array = [[NSMutableArray alloc]init];
    blockThreeARC = ^(id obj){
        [array addObject:obj];
        NSLog(@"array.count-1 = %lu",(unsigned long)array.count);
    };
}

#pragma mark - test8-Malloc
- (void)testBlockMRCEight {
    [self funBlockCopy];
    //虽然没有使用copy
    //这里block在堆上,block在堆上,它所持有的变量也在堆上
    BlockStackTwo_ARC([[NSObject alloc] init]);
    BlockStackTwo_ARC([[NSObject alloc] init]);
    BlockStackTwo_ARC([[NSObject alloc] init]);
}

- (void)funBlockCopy {
    NSMutableArray *array = [[NSMutableArray alloc]init];
    BlockStackTwo_ARC = ^(id obj){
        [array addObject:obj];
        NSLog(@"array.count-1 = %lu",(unsigned long)array.count);
    };
}

#pragma mark - test9-Malloc
- (void)testBlockMRCNine {
    //这里是Malloc
    blockFourARC = funARC(10);
    NSLog(@"blockFour = %d" ,blockFourARC(10));
}

BlockMallocFour_ARC funARC(int rate) {
    //这里不加Copy,不会出错
    return ^(int count){
        return count + rate;
    };
}

#pragma mark - test10-Global
- (void)testBlockMRCTen {
    //这里相当于是全局Block
    blockThreeTestARC = ^{
        NSLog(@"Block");
    };
    
    blockThreeTestARC();
}

#pragma mark - test11-system
- (void)testBlockMRCEleven {
    //这里面用self,不会引起循环引用
    //因为这个block存在于静态方法中,虽然block对self强引用着;
    //但是self却不持有这个静态方法,所以完全可以在block内部使用self
    [UIView animateWithDuration:0.5 animations:^{
        NSLog(@"%@", self);
    }];
    
    //当block不是self的属性时,self并不持有这个block,所以也不存在循环引用
    void(^block)(void) = ^() {
        NSLog(@"%@", self);
    };
    block();
}

#pragma mark - test12-system
- (void)testBlockMRCTwelve {
    NSArray *array = [self getBlockArray];
//    self.array = array;
    BlockTestARC = array[0];
    if (BlockTestARC) {
        BlockTestARC();
    }
//    BlockTestARC();
    NSLog(@"运行结束了。。。");
    // 销毁数组里面的block的时候报错了，block已经释放了。
}

- (id)getBlockArray {
    int val = 10;
    
    //会崩溃
//        NSArray *arr = [[NSArray alloc] initWithObjects:
//                        ^{NSLog(@"ARC-blk0:%d",val);},
//                        ^{NSLog(@"ARC-blk1:%d",val);},nil];
    
    //会崩毁
    return  [[NSArray alloc] initWithObjects:
                               ^{
                                   NSLog(@"ARC-blk0:%d" ,val);
                               },
                               ^{
                                   NSLog(@"ARC-blk1:%d" ,val);
                               },nil];
    
    //不会崩溃、这里编译器不能判断是否需要复制!!!!
    //相当于block还在栈上
//    return  [[NSArray alloc] initWithObjects:
//             [^{NSLog(@"ARC-blk0:%d",val);} copy],
//             [^{NSLog(@"ARC-blk1:%d",val);} copy],nil];
    
}

//基本语法:
//1、NWJlobalBlock是位于全局区的block,它是设置在程序的数据区域（.data区）中
//2、NSStackBlock是位于栈区,超出变量作用域,栈上的Block以及__block变量都被销毁
//3、NSMallocBlock是位于堆区,在变量作用域结束时不受影响。
//4、注意:在 ARC 开启的情况下,将只会有 NSConcreteGlobalBlock 和 NSConcreteMallocBlock类型的block

//当前是ARC环境!!!
//总结:
//1、什么是全局Block
//   a、定义全局变量的地方有block语法时
//   b、block语法的表达式中没有使用应截获的自动变量时
//   c、block语法赋值给成语变量

//2、什么是栈Block <在ARC环境下,不存在栈Block!!!,但是如果block被当成参数,又被返回,在Block>
//   见例题12
//   a、block语法的表达式在函数内局部定义,类似于局部变量
//   b、block语法的表达式中使用截获的自动变量时

//3、什么时候栈Block会复制到堆上<在ARC环境下,除了Global的block,其它都是Malloc的Block>
//   a、调用Block的copy实例方法时
//   b、Block作为函数返回值返回时
//   c、将Block赋值给附有__strong修饰符id类型的类或Block类型成员变量时
//   d、将方法名中含有usingBlock的Cocoa框架方法或GCD的API中传递Block时
//   注意:上面只对Block进行了说明,其实在使用__block变量的Block从栈上复制到堆上时,__block变量也被从栈复制到堆上并被Block所持有

//4、__block变量被复制到堆
//   a、__block变为__Block_byref_i_0结构体
//   b、__Block_byref_i_0结构体里面有__forwarding指针
//   c、栈上的__block变量复制到堆上时,会将成员变量__forwarding的值替换为复制到堆上的__block变量用结构体实例的地址.所以"不管__block变量配置在栈上还是堆上,都能够正确的访问该变量",这也是成员变量__forwarding存在的理由
//   d、++i等价于 ++(i->__forwarding->i);
//      如果__block没有被复制到堆上,则__forwarding指向自己;否则指向堆上变量

//5、Block的copy
//   _NSConcretStackBlock    copy      从栈复制到堆
//   _NSConcretGlobalBlock   copy      什么也不做
//   _NSConcretMallocBlock   copy      引用计数增加
//   注意:在ARC环境下,如果不确定是否要copy block尽管copy即可.ARC会打扫战场


//最终总结:
//一、有人问block是存在栈还是堆,回答如下:
//   1、MRC主要存在堆、栈、数据区域
//      数据区域: a、定义全局变量的地方有block语法时
//               b、block语法的表达式中没有使用应截获的自动变量时
//               c、block语法赋值给成语变量
//          堆: a、使用copy
//              b、Cocoa框架和CGD方法中使用的block
//          栈: a、在局部函数使用Block语法,并且访问了自动变量
//              b、除了以上情况,全部属于栈
//  2、ARC主要存在数据区域和堆,栈目前发现一种特殊情况
//      数据区域: 和MRC相同
//           堆: 包括MRC两种情况
//              c、即使不主动使用copy,默认也是在堆上
//           栈: 目前就发现了一种情况
//              a、作为返回对象的参数,编译器无法判断是否需要到堆.见例12

@end
