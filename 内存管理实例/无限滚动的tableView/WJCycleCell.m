//
//  WJCycleCell.m
//  Demo
//
//  Created by 汪俊 on 2019/6/14.
//  Copyright © 2019年 sogubaby. All rights reserved.
//

#import "WJCycleCell.h"
#import "UIView+WJFrame.h"

@implementation WJCycleCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
}

- (instancetype)initWithIdentifier:(NSString *)identifiy {
    if (self = [super init]) {
        _identifiy = identifiy;
        self.titleLabel = [UILabel new];
        [self addSubview:self.titleLabel];
        self.titleLabel.font = [UIFont systemFontOfSize:20];
        self.titleLabel.frame = CGRectMake(0, 50, kScreenWidth, 50);
        self.titleLabel.textColor = [UIColor whiteColor];
        
        self.imageView = [[UIImageView alloc] init];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
    self.titleLabel.wj_centerY = self.wj_height / 2.0;
}

@end
