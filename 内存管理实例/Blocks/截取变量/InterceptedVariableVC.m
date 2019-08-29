//
//  InterceptedVariableVC.m
//  内存管理实例
//
//  Created by 汪俊 on 2018/5/7.
//  Copyright © 2018年 汪俊. All rights reserved.
//

#import "InterceptedVariableVC.h"

int globalCount = 10;
static int staticCount = 10;

@interface InterceptedVariableVC ()

@end

@implementation InterceptedVariableVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //截获自动变量
    [self interceptedVariable];
    //__block变量
    [self changeInterceptedVariable];
    //静态变量
    [self staticVariable];
    //静态全局变量
    [self staticGlobalVariable];
    //全局变量
    [self globalVariable];
    //字符串数组
    //[self charArrayCWrong];
    //字符串指针
    //[self charArrayCRight];
}

//截获自动变量
- (void)interceptedVariable {
    int val = 10;
    
    void (^blk)(void) = ^{
        NSLog(@"截获自动变量val = %d",val);//10
    };
    
    val = 2;
    blk();
}

//__block变量
- (void)changeInterceptedVariable {
    __block int val = 10;
    
    void (^blk)(void) = ^{
        NSLog(@"__block变量val = %d",val);//2
        //不加__block,这里会报错❌
        val = 1;
    };
    
    //val是__block类型,这里会影响block输出的
    val = 2;
    blk();
    //val是__block类型,这里会影响block输出的
    NSLog(@"__block变量val = %d",val);//1
}

//静态变量
- (void)staticVariable {
    static int val = 10;
    
    void (^blk)(void) = ^{
        NSLog(@"staticval = %d",val);//2
        val = 1;
    };
    
    //val是静态变量,会影响block输出
    val = 2;
    blk();
    //val是静态变量,会影响block输出
    NSLog(@"staticval = %d",val);//1
}

//静态全局变量
- (void)staticGlobalVariable {
    void (^blk)(void) = ^{
        NSLog(@"StaticGlobal = %d",staticCount);//2
        staticCount = 1;
    };
    
    //staticCount是静态全局变量,会影响block输出
    staticCount = 2;
    blk();
    //staticCount是静态全局变量,会影响block输出
    NSLog(@"StaticGlobal = %d" ,staticCount);//1
}

//全局变量
- (void)globalVariable {
    void (^blk)(void) = ^{
        NSLog(@"Global = %d" ,globalCount);//2
        globalCount = 1;
    };
    
    //count是静态全局变量,会影响block输出
    globalCount = 2;
    blk();
    //val是静态全局变量,会影响block输出
    NSLog(@"Global = %d",globalCount);//1
}

//C语言字符串数组
//会有问题:截获自动变量的方法并没有实现对C语言数组的截获
- (void)charArrayCWrong {
    const char text[] = "hello";
    void (^blk)(void) = ^{
        //这里会报错❌
//        printf("%c\n" ,text[0]);
    };
    blk();
    printf("%c\n",text[0]);
}

//C语言字符串数组--无问题
- (void)charArrayCRight {
    const char *text = "hello";
    void (^blk)(void) = ^{
        //这里正常
        printf("字符 = %c\n" ,text[0]);//h
        
        //sizeof
        const char temp[] = "hello";
        printf("sizeof-*text = %lu\n",sizeof(text));//8
        //包含\0在内
        printf("sizeof-temp[] = %lu\n",sizeof(temp));//6
    };
    
    blk();
}

//总结:
//1、针对自动变量也就是局部变量,在不加__block的情况下,只能截获数值,不能改变数值
//2、如果变量是静态变量、静态全局变量、全局变量,则可以进行截取并修改值
//3、C语言中数组是不能被截获的,只能使用指针


@end
