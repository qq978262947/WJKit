//
//  ExampleBlockMRCVC.m
//  内存管理实例
//
//  Created by 汪俊 on 2018/5/7.
//  Copyright © 2018年 汪俊. All rights reserved.
//

#import "ExampleBlockMRCVC.h"

@interface ExampleBlockMRCVC ()

@end

@implementation ExampleBlockMRCVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self exampleBlock];
}

//Block例题
- (void)exampleBlock
{
//    exampleA_MRC();
//    exampleB_MRC();
//    exampleC_MRC();
//    exampleD_MRC();
//    exampleE_MRC();
}

//-----------第一道题：--------------
void exampleA_MRC() {
    char a = 'A';
    ^{
        printf("%c\n", a);
    }();
}
//A.始终能够正常运行

//A.始终能够正常运行
//B.只有在使用ARC的情况下才能正常运行
//C.不使用ARC才能正常运行
//D.永远无法正常运行

//-----------第二道题：选项同第一题--------------
void exampleB_addBlockToArray_MRC(NSMutableArray *array)
{
    char b = 'B';
    //在MRC情况下,当前block在栈下面,里面的引用变量也在栈下面
    //在超出函数作用域的情况下,使用block,block要使用变量b,肯定崩溃
    //解决办法:
    //      a、把block进行复制
    //      b、把变量b改为全局全局变量或者静态变量
    [array addObject:^{
        printf("%c\n", b);
    }];
}

void exampleB_MRC()
{
    NSMutableArray *array = [NSMutableArray array];
    exampleB_addBlockToArray_MRC(array);
    void (^block)(void) = [array objectAtIndex:0];
    block();
}
//B.只有在使用ARC的情况下才能正常运行

//A.始终能够正常运行
//B.只有在使用ARC的情况下才能正常运行
//C.不使用ARC才能正常运行
//D.永远无法正常运行

//-----------第三道题：选项同第一题--------------
void exampleC_addBlockToArray_MRC(NSMutableArray *array)
{
    //因为没有用到自动变量
    //这里引用的是常量,block相当于是在数据区,所以不会崩溃
    [array addObject:^{printf("C\n");}];
}

void exampleC_MRC()
{
    NSMutableArray *array = [NSMutableArray array];
    exampleC_addBlockToArray_MRC(array);
    void (^block)(void) = [array objectAtIndex:0];
    block();
}
//A.始终能够正常运行

//A.始终能够正常运行
//B.只有在使用ARC的情况下才能正常运行
//C.不使用ARC才能正常运行
//D.永远无法正常运行

//-----------第四道题：选项同第一题--------------
typedef void (^dBlockMRC)(void);

dBlockMRC exampleD_getBlock_MRC()
{
    char d = 'D';
    //这里这样写,编译直接会出错.
    //return ^{printf("%c\n", d);};
    
    //这里使用了自动变量,所以这里的block放在栈.
    //这里必须使用copy,把block复制到堆上.否则,立马被释放了.
    return [^{printf("%c\n", d);} copy];
}

void exampleD_MRC()
{
    dBlockMRC blockMRC;
    blockMRC = exampleD_getBlock_MRC();
    blockMRC();
}
//B.只有在使用ARC的情况下才能正常运行

//A.始终能够正常运行
//B.只有在使用ARC的情况下才能正常运行
//C.不使用ARC才能正常运行
//D.永远无法正常运行

//-----------第五道题：选项同第一题--------------
typedef void (^eBlockMRC)(void);

eBlockMRC exampleE_getBlock_MRC()
{
    char e = 'E';
    //这里编译不会报错
    //运行也不会出错,ARC 环境下是会把block里的变量复制到堆里面的 ,对比第4题
    void (^block)(void) = ^{
        printf("%c\n", e);
    };
    return block;
}

void exampleE_MRC()
{
    eBlockMRC block = exampleE_getBlock_MRC();
    block();
}
//B.只有在使用ARC的情况下才能正常运行
//注意:如果打开编译器优化,则不可以正常运行

//A.始终能够正常运行
//B.只有在使用ARC的情况下才能正常运行
//C.不使用ARC才能正常运行
//D.永远无法正常运行

/*****************************************/
//答案:

//例子1
//A正确
//这个例子可以正常运行.储存exampleA的栈只有在block停止执行之后才会释放,因此,无论此Block由系统分配到栈中还是我们自己手动分配到堆中,它都可以正常执行

//例子2
//B正确
//如果不使用ARC,这个block是一个NSStackBlock,分配给exampleB_addBlockToArray的栈上.而当它在exampleB中执行的时候,由于栈被清空，block不再有效
//而使用ARC的话,block会分配到堆中,作为一个自动释放的NSMallocBlock


//例子3
//A正确
//由于block在自己的环路中不会抓取任何变量,它不需要在在运行的时候设置state,它会作为一个NWJlobalBlock编译.它既不是栈也不是堆,而是代码片段的一部分.所以它始终都能正常运行.


//例子4
//B正确
//这个例子和例子2类似.如果不使用ARC,block会在exampleD_getBlock的栈上创建起来.然后当功能返回的时候会立即失效.
//然而,以这个例子来说,这个错误非常明显,所以编译器进行编译会失败,错误提示是：error: returning block that lives on the local stack（错误,返回的block位于本地的栈）

//例子5
//B正确
//这个例子和例子4类似,除了编译器没有认出有错误,所以代码会进行编译然后崩溃.更糟糕的是,这个例子比较特别,如果你关闭了优化,则可以正常运行.所以在测试的时候需要注意.
//而如果使用ARC的话,block则会正确的位于堆上,作为一个自动释放的NSMAllocBlock.

//结论:
//这套小测试有什么意义呢？意义就是要一直使用ARC。使用ARC，block大部分情况下都可以正常运行。

//如果不使用ARC，谨慎起见，可以block = [[block copy] autorelease]，这样block会比申明它的栈flame的有效期长。这样block会被作为一个NSMAllocBlock强制复制到堆上。

//但是，当然不会这么简单，根据苹果的文档，
//Block只有当你在ARC模式下传递block到栈上才会工作,比如说返回的时候.你不需要再次调用Block Copy了.但是当block从栈上传递到 arrayWithObjects: 和其他做了一个retain的方法是时,仍然需要使用[^{} copy].

//但是有一个LLVM的维护者之后也说过:
//我们认为这是编译器的bug,它现在已经修复了.但是Xcode以后是否会在以后发布的新版本中解决这个问题,我也不知道.
//所以,希望,苹果也把它认为是一个bug,在以后的新版本中会解决这个问题.让我们看看会怎么样吧.


@end
