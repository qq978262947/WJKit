//
//  BlockAchieveVC.m
//  内存管理实例
//
//  Created by 汪俊 on 2018/5/7.
//  Copyright © 2018年 汪俊. All rights reserved.
//

#import "BlockAchieveVC.h"

@interface BlockAchieveVC ()

@end

@implementation BlockAchieveVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

//内部实现原理
//Objective-C高级编程
#pragma mark - block内部解析
- (void)blockPrinciple {
    //__block_impl:更像一个block的基类，所有block都具备这些字段
    //__main_block_impl_0:block变量,0表示第0个block.
    //__main_block_func_0:虽然block叫匿名函数.但是,还是被编译器起了个名字
    //__main_block_desc_0:block的描述.注意,他有一个实例__main_block_desc_0_DATA
}

//捕获自动变量原理分析
#pragma mark - 自动变量如何传值解析
- (void)InterceptedVariable {
    int val = 10;
    void (^blk)(void) = ^{
        printf("val=%d\n",val);//10
    };
    val = 2;
    blk();
}
//分析如下:

//1、block内部结构体:
//__main_block_impl_0
//{
//   void *isa;
//   int Flags;
//   int Reserved;
//   void *FuncPtr;
//   struct __main_block_desc_0 *Desc;
//   int val；
//}

//2、val是如何传递到block结构体中的?
//int main()
//{
//    struct __main_block_impl_0 *blk =  &__main_block_impl_0(__main_block_func_0,&__main_block_desc_0_DATA,val);
//}
//备注:这里传入了一个val

//3、传入block结构体后,怎么使用
//static struct __main_block_func_0(struct __main_block_impl_0 *__cself)
//{
//    printf("val=%d\n"，__cself-val);
//}
//备注:类似于OC的self.


//_block说明符
#pragma mark - __block内部解析
- (void)blockSpecifier {
    //使用__block才能改变截取自动变量的值
    __block int val = 10;
    void (^blk)(void) = ^{
        val = 1;
        
    };
    blk();
}

//__block内部代码解析:
//struct __block_byref_val_0
//{
//    void *__isa;
//    __block_byref_val_0 *__forwarding;
//    int _flags;
//    int __size;
//    int val;
//}

//以上代码等价于:
//__block_byref_val_0 val = {
//    0,
//    &val,
//    0,
//    sizeof(__block_byref_val_0),
//    10
//};//自己持有自己的指针
//但是这里不能直接保存val的指针,因为val是栈上的,保存栈变量的指针很危险


//总结:
//1、参考文章
//   a、blocl内部实现
//      https://blog.csdn.net/hherima/article/details/38586101

@end
