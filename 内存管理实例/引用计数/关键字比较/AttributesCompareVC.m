//
//  AttributesCompareVC.m
//  内存管理实例
//
//  Created by 汪俊 on 2018/5/7.
//  Copyright © 2018年 汪俊. All rights reserved.
//

#import "AttributesCompareVC.h"

@interface AttributesCompareVC ()

@end

@implementation AttributesCompareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //__weak与__block区别
//    其实这个问题在现在来说主要就是2个区别：
//
//    block下循环引用的问题
//    __block本身并不能避免循环引用，避免循环引用需要在block内部把__block修饰的obj置为nil
//    __weak可以避免循环引用，但是其会导致外部对象释放了之后，block 内部也访问不到这个对象的问题，我们可以通过在 block 内部声明一个 __strong
//    的变量来指向 weakObj，使外部对象既能在 block 内部保持住，又能避免循环引用的问题
//    __block与__weak功能上的区别。
//    __block会持有该对象，即使超出了该对象的作用域，该对象还是会存在的，直到block对象从堆上销毁；而__weak仅仅是将该对象赋值给weak对象，当该对象销毁时，weak对象将指向nil；
//    __block可以让block修改局部变量，而__weak不能。
//    另外，MRC中__block是不会引起retain；但在ARC中__block则会引起retain。所以ARC中应该使用__weak。
    
    
    // copy与strong区别
//    strong，用来修饰ObjC对象。举例（set方法）
//    //    ARC对应写法
//    - (void)setCount:(NSObject *)count { _count = count;}
//  注意点：  使用set方法赋值时，实质上是会先保留新值，再释放旧值，再设置新值，避免新旧值一样时导致对象被释放的的问题。
    
//    copy，用来修饰ObjC对象。举例（set方法）
//    release旧值，再copy新值（拷贝内容）一般用来修饰String、Dict、Array等需要保护其封装性的对象，尤其是在其内容可变的情况下，因此会拷贝（深拷贝）一份内容給属性使用，避免可能造成的对源内容进行改动。
//    　　使用set方法赋值时，实质上是会先拷贝新值，再释放旧值，再设置新值。 基本和上面一样 只是最后一句改为_count = [count copy];
//    　　实际上，遵守NSCopying的对象都可以使用copy，当然，如果你确定是要共用同一份可变内容，你也可以使用strong或retain。
    
    //__weak与unsafe_retained区别
//    __weak修饰符
//    弱引用不改变对象的引用计数，并且，在持有某对象的弱应用时，若改对象被废弃，则此弱引用将自动失效且处于nil被赋值的状态。
    
//   __unsafe_unretained修饰符
//   和__weak基本一致，只是不会被自动置nil（现在基本上看不到使用）
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
