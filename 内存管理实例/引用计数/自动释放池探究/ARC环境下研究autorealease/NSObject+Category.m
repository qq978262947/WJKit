//
//  NSObject+Category.m
//  内存管理实例
//
//  Created by 汪俊 on 2018/5/3.
//  Copyright © 2018年 汪俊. All rights reserved.
//

#import "NSObject+Category.h"
//#import <objc/objc.h>
#import <objc/message.h>
#import <objc/runtime.h>

@implementation NSObject (Category)

//这个理解需要以下代码辅助
//{
//    id __strong obj = [NSMutableArray NSArray];
//}

//等价于以下代码
//{
//    id obj = objc_msgSend(NSMutableArray, @selector(array));
//    objc_retainAutoreleasedReturnValue(obj);
//    objc_release(obj);
//}

//+ (id)array
//{
//    return [[NSMutableArray alloc] init];
//}

//+ (int)array
//{
//    id obj = objc_msgSend([NSMutableArray class], @selector(alloc));
//    objc_msgSend(obj, @selector(init));
//    return objc_autoreleaseReturnValue(obj);
//}

//总结:
//1、[NSMutableArray NSArray]本身是决定加入自动释放池的,为了在ARC优化编译器,特意加入了objc_autoreleaseReturnValue(obj);
//2、[NSMutableArray NSArray] + objc_retainAutoreleasedReturnValue(obj)就相当于是[[NSMutableArray alloc] init];自己持有、不加入自动释放池了
//3、以上是针对是ARC,MRC下肯定是适应前面的四条规则,存在自动释放池中


+ (id)Object {
    return [NSMutableArray array];//不会崩溃
}

//解析如下:
//1、return [NSMutableArray array] 不会崩溃原因
//等价代码如下:
//+ (id)Object
//{
//     //由上面array编译源码可知:
//     //这里的obj相当于[[[NSMutableArray alloc]init]autorelease];
//     id obj = objc_msgSend(NSMutableArray, @selector(array));
//     因为这里没有出现objc_retainAutoreleasedReturnValue(obj)
//     return obj;
//}

+ (id)Objects {
    NSMutableArray *marr = [NSMutableArray array];//崩溃
    return marr;
}

//2、NSMutableArray *marr = [NSMutableArray array];//崩溃
//   return marr;
//等价代码如下:
//+ (id)Object
//{
//    1、以下两句➡️这个obj相当于[[NSMutableArray alloc]init]>
//    id obj = objc_msgSend(NSMutableArray, @selector(array));
//    objc_retainAutoreleasedReturnValue(obj);

//    2、这里相当于执行release，和前面的objc_retain方法相消
//    objc_retain(obj);
//    objc_storeStrong(&obj，nil);
//
//    3、外面如果有强引用指针,则不加入自动释放池
//    return _objc_autoreleaseReturnValue(obj);
//}

//最终等价于以下结果:
//+ (id)Object
//{
//    id obj = objc_msgSend(NSMutableArray, @selector(alloc));
//    objc_msgSend(NSMutableArray, @selector(init));
//    同样是外部是强引用指针的话,这里不进行autorelease
//    return _objc_autoreleaseReturnValue(obj);
//}

+ (id)Objectss {
    return [[NSMutableArray alloc]init];//崩溃
}

//3、return [[NSMutableArray alloc]init];//崩溃
//等价代码如下:
//+ (id)Objectss
//{
//    id obj = objc_msgSend(NSMutableArray, @selector(alloc));
//    objc_msgSend(obj, @selector(init));
//    同样外部如果是强引用,则出现objc_retainAutoreleasedReturnValue(obj),这里不进行autorelease
//    return objc_autoreleaseReturnValue(obj);
//}

+ (id)Objectsss {
    id obj = [[NSMutableArray alloc]init];//崩溃
    return obj;
}
//4、id obj = [[NSMutableArray alloc]init];//崩溃
//   return obj;
//等价代码如下:
//+ (id)Objectsss
//{
//   id obj = objc_msgSend(NSMutableArray, @selector(alloc));
//   objc_msgSend(obj, @selector(init));
//
//   objc_retain(obj);
//   objc_storeStrong(&obj，nil);//两两相互抵消
//
//   return objc_autoreleaseReturnValue(obj);
//}

+ (id)copyObject {
    return [NSMutableArray array];//崩溃
}


//解析如下：
//5、return [NSMutableArray array]崩溃
//等价代码如下:
//+ (id)allocObject
//{
//   1、这个obj相当于[[NSMutableArray alloc]init];
//   id obj = objc_msgSend(NSMutableArray, @selector(array));
//   objc_retainAutoreleasedReturnValue(obj);
//   return obj;
//}

+ (id)copyObjects {
    id obj = [NSMutableArray array];
    return obj;
}

//解析如下:
//6、
//+ (id)copyObjects
//{
//    1、这个obj相当于[[NSMutableArray alloc]init];
//    id obj = objc_msgSend(NSMutableArray, @selector(array));
//    objc_retainAutoreleasedReturnValue(obj);
//
//    objc_retain(obj);
//    objc_storeStrong(&obj，nil);//两两相互抵消

//    return obj;
//}

+ (id)copyObjectss {
    return [[NSMutableArray alloc]init];
}

//解析如下;
//7、
//+ (id)copyObjectss
//{
//   id obj = objc_msgSend(NSMutableArray, @selector(alloc));
//   objc_msgSend(obj, @selector(init));
//   return obj;
//}

+ (id)copyObjectsss {
    id obj = [[NSMutableArray alloc]init];
    return obj;
}

//解析如下:
//8、
//+ (id)copyObjectsss
//{
//   id obj = objc_msgSend(NSMutableArray, @selector(alloc));
//   objc_msgSend(obj, @selector(init));
//
//    objc_retain(obj);
//    objc_storeStrong(&obj，nil);//两两相互抵消
//
//    return obj;
//}


//总结:
//1、不是以alloc、new、copy、mutableCopy开头的方法,返回的只有两种可能
//   a、[obj autorelease] //一定是加入自动释放池
//   b、objc_autoreleaseReturnValue(obj) //取决于外面的指针
//2、以alloc、new、copy、mutableCopy开头的方法,返回的只有一种
//   a、obj

@end
