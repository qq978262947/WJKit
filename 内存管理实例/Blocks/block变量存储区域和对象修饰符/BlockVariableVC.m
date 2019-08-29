//
//  BlockVariableVC.m
//  内存管理实例
//
//  Created by 汪俊 on 2018/5/7.
//  Copyright © 2018年 汪俊. All rights reserved.
//

#import "BlockVariableVC.h"
typedef void (^BlockTest)(id);
BlockTest blockTemp;

@interface BlockVariableVC ()

@end

@implementation BlockVariableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self testBlockOne];
//    [self testBlockTwo];
//    [self testBlockThree];
    [self testBlockFour];
}

- (void)testBlockOne {
    __block int val = 0;
    //这里block不管是否用copy,打印值都是2
    void (^blk)(void) = [^{
        ++val;//val = 2
    } copy];
    
    ++val;//val = 1
    blk();
    NSLog(@"val = %d",val);//2
}

- (void)testBlockTwo {
    [self funBlockTwo];
    //这里不会崩溃,因为block在Malloc上
    blockTemp([[NSObject alloc] init]);
    blockTemp([[NSObject alloc] init]);
    blockTemp([[NSObject alloc] init]);
}

//strong修饰符
- (void)funBlockTwo {
    id array = [[NSMutableArray alloc]init];
    
    blockTemp = ^(id obj){
        [array addObject:obj];
        NSLog(@"array.count-2 = %lu",(unsigned long)[array count]);
    };
}
//这里block对strong修饰符的array具有强引用

//weak修饰符
- (void)testBlockThree {
    [self funBlockThree];
    //这里不会崩溃,因为block在Malloc上
    blockTemp([[NSObject alloc] init]); // 0
    blockTemp([[NSObject alloc] init]); // 0
    blockTemp([[NSObject alloc] init]); // 0
}

- (void)funBlockThree {
    id array = [[NSMutableArray alloc]init];
    id __weak array2 = array;
    
    blockTemp = ^(id obj){
        [array2 addObject:obj];
        NSLog(@"array.count-3 = %lu",[array2 count]);
    };
}

//这里weak会有问题;由于strong修饰符的array,在作用域结束会被释放,weak被置为nil
- (void)testBlockFour {
    [self funBlockFour];
    //这里不会崩溃,因为block在Malloc上
    blockTemp([[NSObject alloc] init]);
    blockTemp([[NSObject alloc] init]);
    blockTemp([[NSObject alloc] init]);
}

- (void)funBlockFour {
    id array = [[NSMutableArray alloc]init];
    __block id __weak array2 = array; // 就是这里是__weak修饰的，所以会有问题 - 去掉后的打印结果会是 1，2，3.和我们预期一致
    
    blockTemp = ^(id obj){
        [array2 addObject:obj];
        NSLog(@"array.count-3 = %lu",[array2 count]);
    };
}
//这里也没有用,weak具有强大的作用


//总结:
//1、当block被复制到堆上时,它所捕获的对象、变量也全部复制到堆上
//2、__block是一个结构体,结构体中有一个字段叫__forwarding,用于指向自动这个结构体.
//  那么有了这个__forwarding指针，无论是栈上的block还是被拷贝到堆上，那么都会正确的访问自动变量的值
//3、在block在堆堆前提下,使用自动变量的话,如果自动变量用weak修饰,则会被马上置为nil

@end
