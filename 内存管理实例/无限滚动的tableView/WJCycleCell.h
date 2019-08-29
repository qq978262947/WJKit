//
//  WJCycleCell.h
//  Demo
//
//  Created by 汪俊 on 2019/6/14.
//  Copyright © 2019年 sogubaby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJCycleCell : UIView

@property (nonatomic, strong) NSString *identifiy;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (instancetype)initWithIdentifier:(NSString *)identifiy;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;

@end
