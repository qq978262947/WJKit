//
//  BlockSyntaxVC.m
//  内存管理实例
//
//  Created by 汪俊 on 2018/5/7.
//  Copyright © 2018年 汪俊. All rights reserved.
//

#import "BlockSyntaxVC.h"

@interface BlockSyntaxVC ()

@end

@implementation BlockSyntaxVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

//总结:
//一、Block语法(这里是语法,语法,语法!!!)

//1、Block被称为"带有自动变量值的匿名函数",Block也是OC对象
//2、与C语言相比,仅有两点不同
//   a、没有函数名
//   b、带有"^"
//3、Block语法形式:
//   a、^ 返回值类型 (参数列表) {表达式}
//      ^int (int count){return count + 1;}
//   b、^ (参数列表) {表达式}
//      ^(int count){return count + 1;}
//      等价于:
//      ^void (int count){return count + 1;}
//      省略返回值类型:1、如果有return,就使用返回值类型
//                  2、如果没有返回值,就使用void
//                  3、有多个return,返回值类型必须相同
//
//   c、^ {表达式}
//      ^{NSLog(@"我是Block")};
//      等价于:
//      ^void (void){NSLog(@"我是Block")};

//二、Block类型变量(这是变量,变量,变量!!!)

//Block类型变量类似于"函数指针"
//1、定义形式
//   返回值类型(^Block名称)(参数类型) = ^(参数列表) {表达式}//这里返回值类型被省略
//   int(^blk)(int) = ^(int count){return count + 1;}
//   int(^blk)(int,int) = ^(int count,int rate){return count + rate;}

//2、typedef定义Block
// typedef int (^blk_t)(int);

//背景:
//   因为Block可以当函数参数和函数的返回值
//   void fun (int(^blk)(int)) //Block参数
//   int (^fun()) (int) //Block返回值
//   {
//     return ^(int count){return count + 1;}
//   }

//转化:
//   void fun(blk_t blk)
//   blk_t fun()
//   {
//       return ^(int count){return count + 1;}
//   }

//3、参考文章
//   1、Block编程
//   https://blog.csdn.net/hherima/article/details/17352053

@end
