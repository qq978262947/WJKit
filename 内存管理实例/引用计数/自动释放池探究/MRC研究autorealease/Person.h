//
//  Person.h
//  内存管理实例
//
//  Created by 汪俊 on 2018/4/28.
//  Copyright © 2018年 汪俊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Animal.h"

@interface Person : NSObject {
    //定义Person对象持有Animal对象
    Animal *_item;
}

- (void)setItem:(Animal *)item;
- (Animal *)item;

@end
