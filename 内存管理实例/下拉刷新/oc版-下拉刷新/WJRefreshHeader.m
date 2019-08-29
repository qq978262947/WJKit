//
//  WJRefreshHeader.m
//  内存管理实例
//
//  Created by 汪俊 on 2018/6/4.
//  Copyright © 2018年 汪俊. All rights reserved.
//

#import "WJRefreshHeader.h"
#import "UIView+WJFrame.m"
#import "UIScrollView+WJFrame.h"

#pragma mark - 控件的刷新状态
typedef enum {
    WJRefreshStatePulling = 1, // 松开就可以进行刷新的状态
    WJRefreshStateNormal = 2, // 普通状态
    WJRefreshStateRefreshing = 3, // 正在刷新中的状态
    WJRefreshStateWillRefreshing = 4
} WJRefreshState;

#define WJRefreshViewHeight 60.0
#define WJRefreshFastAnimationDuration 0.25
static void * WJRefreshContentOffsetContext             = &WJRefreshContentOffsetContext;
//static void * WJRefreshcontentInsetContext              = &WJRefreshcontentInsetContext; // 似乎不需要contentInset

@interface WJRefreshHeader ()

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, copy) RefreshingBlock wj_refreshingBlock;

@property (nonatomic, strong) id wj_target;
@property (nonatomic, assign) SEL wj_action;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) WJRefreshState state;

@property (nonatomic, assign) UIEdgeInsets scrollViewOriginalInset;

@end

@implementation WJRefreshHeader

#pragma MARK -Life Style
+ (instancetype)headerWithRefreshingBlock:(RefreshingBlock)refreshingBlock {
    WJRefreshHeader *header = [[WJRefreshHeader alloc]init];
    header.wj_refreshingBlock = refreshingBlock;
    return header;
}

+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action {
    WJRefreshHeader *header = [[WJRefreshHeader alloc]init];
    header.wj_target = target;
    header.wj_action = action;
    return header;
}

- (instancetype)initWithFrame:(CGRect)frame {
    frame.size.height = WJRefreshViewHeight;
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor orangeColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.state = WJRefreshStateNormal;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        self.scrollView = (UIScrollView *)newSuperview;
        [self removeObservers];
        if ([self.scrollView isKindOfClass:[UIScrollView class]]) {
            [self addObservers];
            self.wj_x = 0;
            self.wj_width = newSuperview.wj_width;
            self.wj_y = - self.wj_height;
            _scrollViewOriginalInset = _scrollView.contentInset;
//            NSLog(@"currentOffsetY:%f - happenOffsetY:%f", _scrollViewOriginalInset.top, happenOffsetY);
        }
       
    }
}

#pragma MARK - public
- (void)beganRefreshing {
    self.alpha = 1.0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(beganDropDownRefreshing:)
                                                userInfo:nil
                                                 repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)endRefreshing {
    [self.timer invalidate];
    self.timer = nil;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0.0;
    }];
}

#pragma MARK - private
- (void)beganDropDownRefreshing:(NSTimer *)timer {
    
    int red = arc4random() % 256;
    int green = arc4random() % 256;
    int blue = arc4random() % 256;
    UIColor *randomColor = [UIColor colorWithRed:(red)/255.0 green:(green)/255.0 blue:(blue)/255.0 alpha:1.0];
    [UIView animateWithDuration:0.5 animations:^{
        self.backgroundColor = randomColor;
    }];
}

- (void)addObservers {
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:options context:WJRefreshContentOffsetContext];
//    [self.scrollView addObserver:self forKeyPath:@"contentInset" options:options context:WJRefreshcontentInsetContext];
}

- (void)removeObservers {
    [self.superview removeObserver:self forKeyPath:@"contentOffset"];
//    [self.superview removeObserver:self forKeyPath:@"contentInset"];
}

#pragma mark - observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    // 不能跟用户交互就直接返回
    if (!self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden) return;
    
    // 如果正在刷新，直接返回
    if (self.state == WJRefreshStateRefreshing) return;
    
    if (context == WJRefreshContentOffsetContext) {
        /**
         * 此处需要做哪些事
         * 1. 监控偏移，判断刷新状态及对应刷新控件显示 （主要）
         * 2. 其它 - 健壮性判断
         */
        [self adjustStateWithContentOffset];
    }
}

- (void)adjustStateWithContentOffset {
    // 当前的contentOffset
    CGFloat currentOffsetY = self.scrollView.contentOffset.y;
    // 尾部控件刚好出现的offsetY
    CGFloat happenOffsetY = - self.scrollViewOriginalInset.top;
    // 如果是向下滚动到看不见尾部控件，直接返回
    if (currentOffsetY <= happenOffsetY) return;
    
    if (self.scrollView.isDragging) {
        // 普通 和 即将刷新 的临界点
        CGFloat normal2pullingOffsetY = happenOffsetY + self.wj_height;
        
        if (self.state == WJRefreshStateNormal && currentOffsetY > normal2pullingOffsetY) {
            // 转为即将刷新状态
            self.state = WJRefreshStatePulling;
        } else if (self.state == WJRefreshStatePulling && currentOffsetY <= normal2pullingOffsetY) {
            // 转为普通状态
            self.state = WJRefreshStateNormal;
        }
    } else if (self.state == WJRefreshStatePulling) {// 即将刷新 && 手松开
        // 开始刷新
        self.state = WJRefreshStateRefreshing;
    }
}

#pragma mark 设置状态
- (void)setState:(WJRefreshState)state {
    // 1.一样的就直接返回
    if (_state == state) return;
    // 2.保存旧状态
    WJRefreshState oldState = self.state;
    
    // 4.根据状态来设置属性
    switch (state) {
        case WJRefreshStateNormal: {
            // 刷新完毕
            if (WJRefreshStateRefreshing == oldState) {
//                self.arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
//                [UIView animateWithDuration:WJRefreshSlowAnimationDuration animations:^{
//                    self.scrollView.contentInsetBottom = self.scrollViewOriginalInset.bottom;
//                }];
            } else {
                // 执行动画
//                [UIView animateWithDuration:WJRefreshFastAnimationDuration animations:^{
//                    self.arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
//                }];
                [self beganRefreshing];
            }
            
//            CGFloat deltaH = [self heightForContentBreakView];
//            int currentCount = [self totalDataCountInScrollView];
//            // 刚刷新完毕
//            if (WJRefreshStateRefreshing == oldState && deltaH > 0 && currentCount != self.lastRefreshCount) {
//                self.scrollView.contentOffsetY = self.scrollView.contentOffsetY;
//            }
            break;
        }
            
        case WJRefreshStatePulling: {
//            [UIView animateWithDuration:WJRefreshFastAnimationDuration animations:^{
//                self.arrowImage.transform = CGAffineTransformIdentity;
//            }];
            break;
        }
            
        case WJRefreshStateRefreshing: {
//            // 记录刷新前的数量
//            self.lastRefreshCount = [self totalDataCountInScrollView];
//
//            [UIView animateWithDuration:WJRefreshFastAnimationDuration animations:^{
//                CGFloat bottom = self.height + self.scrollViewOriginalInset.bottom;
//                CGFloat deltaH = [self heightForContentBreakView];
//                if (deltaH < 0) { // 如果内容高度小于view的高度
//                    bottom -= deltaH;
//                }
//                self.scrollView.contentInsetBottom = bottom;
//            }];
            [UIView animateWithDuration:WJRefreshFastAnimationDuration animations:^{
                // 1.增加滚动区域
                CGFloat top = self.scrollViewOriginalInset.top + self.wj_height;
                self.scrollView.wj_contentInsetTop = top;
                
                // 2.设置滚动位置
                self.scrollView.wj_contentOffsetY = - top;
            }];
            break;
        }
            
        default:
            break;
    }
}

@end
