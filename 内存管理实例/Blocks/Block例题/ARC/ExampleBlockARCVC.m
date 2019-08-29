//
//  ExampleBlockARCVC.m
//  内存管理实例
//
//  Created by 汪俊 on 2018/5/7.
//  Copyright © 2018年 汪俊. All rights reserved.
//

#import "ExampleBlockARCVC.h"

@interface ExampleBlockARCVC ()

@end

@implementation ExampleBlockARCVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self exampleBlock];
}

//Block例题
- (void)exampleBlock {
    exampleA();
    exampleB();
    exampleC();
    exampleD();
    exampleE();
}

//-----------第一道题：--------------
void exampleA() {
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
void exampleB_addBlockToArray(NSMutableArray *array) {
    char b = 'B';
    [array addObject:^{
        printf("%c\n", b);
    }];
}

void exampleB() {
    NSMutableArray *array = [NSMutableArray array];
    exampleB_addBlockToArray(array);
    void (^block)(void) = [array objectAtIndex:0];
    block();
}
//B.只有在使用ARC的情况下才能正常运行

//A.始终能够正常运行
//B.只有在使用ARC的情况下才能正常运行
//C.不使用ARC才能正常运行
//D.永远无法正常运行

//-----------第三道题：选项同第一题--------------
void exampleC_addBlockToArray(NSMutableArray *array)
{
    [array addObject:^{printf("C\n");}];
}

void exampleC()
{
    NSMutableArray *array = [NSMutableArray array];
    exampleC_addBlockToArray(array);
    void (^block)(void) = [array objectAtIndex:0];
    block();
}
//A.始终能够正常运行

//A.始终能够正常运行
//B.只有在使用ARC的情况下才能正常运行
//C.不使用ARC才能正常运行
//D.永远无法正常运行

//-----------第四道题：选项同第一题--------------
typedef void (^DBlock)(void);

DBlock exampleD_getBlock() {
    char d = 'D';
    return ^{printf("%c\n", d);};
}

void exampleD() {
    exampleD_getBlock()();
}
//B.只有在使用ARC的情况下才能正常运行

//A.始终能够正常运行
//B.只有在使用ARC的情况下才能正常运行
//C.不使用ARC才能正常运行
//D.永远无法正常运行

//-----------第五道题：选项同第一题--------------
typedef void (^EBlock)(void);

EBlock exampleE_getBlock() {
    char e = 'E';
    void (^block)(void) = ^{printf("%c\n", e);};
    return block;
}

void exampleE() {
    EBlock block = exampleE_getBlock();
    block();
}
//B.只有在使用ARC的情况下才能正常运行

//A.始终能够正常运行
//B.只有在使用ARC的情况下才能正常运行
//C.不使用ARC才能正常运行
//D.永远无法正常运行


@end
