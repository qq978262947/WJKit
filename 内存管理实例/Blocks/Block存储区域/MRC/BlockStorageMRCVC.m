//
//  BlockStorageMRCVC.m
//  内存管理实例
//
//  Created by 汪俊 on 2018/5/7.
//  Copyright © 2018年 汪俊. All rights reserved.
//

#import "BlockStorageMRCVC.h"

//Stack
void(^BlockStackOne)(id);
void(^BlockStackTwo)(id);

typedef void(^BlockStackThree)(id);
BlockStackThree blockThree;

//Global
void(^BlockGlobalOne)(void) = ^{ NSLog(@"Global Block");};

//Malloc
void(^BlockMallocOne)(id);
void(^BlockMallocTwo)(void);

typedef void (^BlockMallocThree)(void);
typedef int (^BlockMallocFour)(int);
BlockMallocFour blockFour;

//test
void(^BlockTest)(void);

@interface BlockStorageMRCVC ()
{
    BlockMallocThree blockThreeTest;
}

@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation BlockStorageMRCVC

//当前是MRC环境!!!

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //Stack
//    [self testBlockMRCOne];
//    [self testBlockMRCFive];
//    [self testBlockMRCSeven];
    
    //Global
//    [self testBlockMRCThree];
//    [self testBlockMRCFour];
//    [self testBlockMRCTen];
    
    //Malloc
//    [self testBlockMRCTwo];
//    [self testBlockMRCSix];
//    [self testBlockMRCEight];
//    [self testBlockMRCNine];
    
    //system
//    [self testBlockMRCEleven];
    
    //test
    [self testBlockMRCTwelve];
}

#pragma mark - test1-Stack
- (void)testBlockMRCOne {
    NSInteger i = 10;
    //打断点可以发现,这里是NSStackBlock;在touchesBegan里,会❌ - 补个解释吧！mrc环境下，block不会被截获的变量copy到堆里面，所以函数执行完毕，变量就释放了
    BlockStackOne = ^(id obj){
        NSLog(@"%ld", i);
    };
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    BlockStackOne([[NSObject alloc]init]);
    
    BlockMallocOne([[NSObject alloc]init]);
    [BlockMallocOne release];
}

#pragma mark - test2-Malloc
- (void)testBlockMRCTwo {
    NSInteger i = 10;
    //打断点可以发现,这里是NSMallocBlock
    BlockMallocOne = [^(id obj){
        NSLog(@"%ld", i);
    } copy];
    //copy和release成对使用
}

#pragma mark - test3-Global
- (void)testBlockMRCThree {
    //这里是NWJlobalBlock
    BlockGlobalOne();
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
    //在代码截获自动变量时，生成的block也是在栈区
    //这里是NSStackBlock
    
    int tempValue = 10;
    
    int(^block)(int count) = ^(int count) {
        return count * tempValue;
    };
    
    NSLog(@"block(2) = %d",block(2));
}

#pragma mark - test6-Malloc
- (void)testBlockMRCSix {
    __block NSInteger i = 10;
    BlockMallocTwo = [^{
        ++i;
    } copy];
    
    //11
    ++i;//++(i->__forwarding->i);
    
    //12
    BlockMallocTwo();
    
    NSLog(@"i = %ld", i);
}

#pragma mark - test7-Stack
- (void)testBlockMRCSeven {
    [self funBlock];
    //这里会崩溃,因为block在栈上 (为什么在栈里会崩溃，在block里面不调用array的时候是globalblock没有问题。而栈上的这个block在函数执行完后已经释放了)
    if (blockThree) {
        blockThree([[NSObject alloc] init]);
        blockThree([[NSObject alloc] init]);
        blockThree([[NSObject alloc] init]);
    }
}

- (void)funBlock {
    NSMutableArray *array = [[NSMutableArray alloc]init];
    blockThree = ^(id obj){
        // block中引用了自动变量;否则,可以是全局block
        [array addObject:obj];
        NSLog(@"array.count-1 = %lu" ,(unsigned long)array.count);
    };
}

#pragma mark - test8-Malloc
- (void)testBlockMRCEight {
    [self funBlockCopy];
    //这里block在堆上,block在堆上,它所持有的变量也在堆上
    BlockStackTwo([[NSObject alloc] init]);
    BlockStackTwo([[NSObject alloc] init]);
    BlockStackTwo([[NSObject alloc] init]);
}

- (void)funBlockCopy {
    NSMutableArray *array = [[NSMutableArray alloc]init];
    BlockStackTwo = [^(id obj){
        [array addObject:obj];
        NSLog(@"array.count-1 = %lu",(unsigned long)array.count);
    } copy];
}

#pragma mark - test9-Malloc
- (void)testBlockMRCNine {
    //这里是Malloc
    blockFour = fun(10);
    NSLog(@"blockFour = %d",blockFour(10));
}

BlockMallocFour fun(int rate) {
    //不加copy会提示出错
    return [^(int count){
        return count + rate;
    } copy];
}

#pragma mark - test10-Global
- (void)testBlockMRCTen {
    //这里相当于是全局Block
    //成员变量属性
    blockThreeTest = ^{
        NSLog(@"Block");
    };
    
    blockThreeTest();
}

#pragma mark - test11-system
- (void)testBlockMRCEleven {
    //这里面用self,不会引起循环引用
    //因为这个block存在于静态方法中,虽然block对self强引用着;
    //但是self却不持有这个静态方法,所以完全可以在block内部使用self
    [UIView animateWithDuration:0.5 animations:^{
        NSLog(@"%@", self);
    }];
    
    // 当block不是self的属性时,self并不持有这个block,所以也不存在循环引用 - 也有多重的循环引用的情况。
    // 个人意见-遇到block加一个__weak反而会少思考一些，出现泄漏的概率会少一些，low一些根本无关紧要，想的太多，思路变很难清晰，很容易出错 （可以完成后再修改）
    // 相关资料 - To put a Block into a Collection, it must first be copied. Always. Including under ARC. If you don't, there is risk that the stack allocated Block will be autoreleased and your app will later crash. 翻译： 要将Block放到一个收集容器里面，她首先必须要被copy。通常来说，这要在arc环境下面进行。如果你不这样搞，就会有一个风险：由stack allocate 的block将会被自动释放，然后你的app就妥妥的挂掉了
    void(^block)(void) = ^() {
        NSLog(@"%@", self);
    };
    block();
}

#pragma mark - test12-system
- (void)testBlockMRCTwelve {
    NSArray *array = [self getBlockArray];
    BlockTest = array[0];
    BlockTest();
    NSLog(@"结束了");
}

- (id)getBlockArray {
    int val = 10;
    //这样返回会崩溃
//        return [NSArray arrayWithObjects:
//                ^{
//                    NSLog(@"MRC-blk0:%d",val);
//
//                },
//                ^{
//                    NSLog(@"MRC-blk1:%d",val);
//
//                },nil];
    // 该block存储的栈上的这个block在函数执行完后数组置nil的时候已经被回收了，回收时机是BlockTest()执行完后。我估计应该有[blockTest release];的操作，栈block的自动回收吧，应该和变量有点像。再执行array=nil；release数组里面的元素的时候，是已经释放了的
    
    //这样不会崩溃 - 在堆里面当然没有问题了
//    return [NSArray arrayWithObjects:
//            [^{
//                 NSLog(@"MRC-blk0:%d",val);
//
//             } copy],
//            [^{
//                NSLog(@"MRC-blk1:%d",val);
//
//    } copy],nil];
    
    //这样也没事
    // 这个也是栈block，但是为什么会出现这种情况呢？
    // ⚠️：这些只是我的个人猜测和推断，并没有找到相关的文档，实例来证明。
    // 首先我在BlockTest();加入了BlockTest();1和3都崩溃了，2没有崩溃。1，3都是栈block，而在下面加上array=nil的时候只有一崩溃了。1. 明显是访问了该block，而3却似乎没有访问
    // 打印结果po BlockTest 0x000000010fc9390e    po array[0] 0x00007ffee13a3808
    // 再看看例子1:po array[0] 0x00007ffee913b828         po array[0] 0x00007ffee913b828
    // 数组3里面的block被拷贝了一份
    NSArray *arr = [[NSArray alloc] initWithObjects:
                    ^{
                        NSLog(@"MRC-blk0:%d" ,val);

                    },
                    ^{
                        NSLog(@"MRC-blk1:%d" ,val);

                    },
                    ^{
                        NSLog(@"MRC-blk2:%d" ,val);

                    },nil];
    return arr;
}

//基本语法:
//1、NWJlobalBlock是位于全局区的block,它是设置在程序的数据区域（.data区）中
//2、NSStackBlock是位于栈区,超出变量作用域,栈上的Block以及__block变量都被销毁
//3、NSMallocBlock是位于堆区,在变量作用域结束时不受影响。
//4、注意:在 ARC 开启的情况下,将只会有 NSConcreteGlobalBlock 和 NSConcreteMallocBlock类型的block

//当前是MRC环境!!!
//总结:
//1、什么是全局Block
//   a、定义全局变量的地方有block语法时
//   b、block语法的表达式中没有使用应截获的自动变量时
//   c、block语法赋值给成语变量

//2、什么是栈Block
//   a、block语法的表达式在函数内局部定义,类似于局部变量
//   b、block语法的表达式中使用截获的自动变量时

//3、什么时候栈Block会复制到堆上
//   a、调用Block的copy实例方法时---手动复制
//   b、Block作为函数返回值返回时---手动复制
//   c、将Block赋值给附有__strong修饰符id类型的类或Block类型成员变量时<这里貌似是Global的Block>---不用手动复制
//   d、将方法名中含有usingBlock的Cocoa框架方法或GCD的API中传递Block时---不用手动复制
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

@end
