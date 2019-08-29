//
//  WJCycleTableView.m
//  Demo
//
//  Created by 汪俊 on 2019/6/14.
//  Copyright © 2019年 sogubaby. All rights reserved.
//

#import "WJCycleTableView.h"
#import "WJCycleCell.h"
#import "UIView+WJFrame.h"
#import <objc/runtime.h>

@interface WJCycleCell (WJCycleTableView)

@property (nonatomic, strong) WJIndexPath *wj_indexPath;

@end

@implementation WJCycleCell (WJCycleTableView)

- (WJIndexPath *)wj_indexPath {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setWj_indexPath:(WJIndexPath *)wj_indexPath {
    SEL key = @selector(wj_indexPath);
    objc_setAssociatedObject(self, key, wj_indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@interface WJIndexPath ()

@property (nonatomic, assign) CGFloat offsetLength;
@property (nonatomic, assign) CGFloat length;
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, assign) NSUInteger row;
@property (nonatomic, assign) NSUInteger section;

@end

@implementation WJIndexPath

+ (instancetype)indexPathWithRow:(NSUInteger)row section:(NSUInteger)section {
    WJIndexPath *indexPath = [[self alloc] init];
    indexPath.row = row;
    indexPath.section = section;
    return indexPath;
}

+ (instancetype)indexPathWithIndex:(NSUInteger)index {
    return [[self alloc] initWithIndex:index];
}

- (instancetype)initWithIndex:(NSUInteger)index {
    if (self = [super init]) {
        self.index = index;
    }
    return self;
}


@end

@interface WJDynamicItem : NSObject
<
UIDynamicItem
>

@property (nonatomic, readwrite) CGPoint center;
@property (nonatomic, readonly) CGRect bounds;
@property (nonatomic, readwrite) CGAffineTransform transform;

@end

@implementation WJDynamicItem

- (instancetype)init {
    self = [super init];
    if (self) {
        // Sets non-zero `bounds`, because otherwise Dynamics throws an exception.
        _bounds = CGRectMake(0, 0, 1, 1);
    }
    return self;
}

@end

@interface WJCycleTableView ()
<
UIDynamicAnimatorDelegate
>

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UIDynamicAnimator *animator;
// 减速行为
@property (nonatomic, strong) UIDynamicItemBehavior *decelerationBehavior;
@property (nonatomic, strong) WJDynamicItem *dynamicItem;
@property (nonatomic, assign) CGRect newBounds;
@property (nonatomic, assign) CGRect touchBounds;
@property (nonatomic, assign) BOOL tracking;
@property (nonatomic, assign) BOOL dragging;
@property (nonatomic, assign) BOOL decelerating;
@property (nonatomic, assign) NSInteger numberOfSections;
@property (nonatomic, assign) CGFloat allHeight;

// 缓存池
@property (nonatomic, strong) NSMutableArray *cellBufferPool;
@property (nonatomic, strong) NSMutableDictionary *visibleCellsMap;
@property (nonatomic, strong) NSMutableArray *visibleCells;
@property (nonatomic, strong) NSMutableArray *indexPathArray;

@end

@implementation WJCycleTableView

#pragma mark - life style
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

#pragma mark - public
- (void)registerClass:(nullable Class)cellClass forCellReuseIdentifier:(NSString *)identifier {
    [self.visibleCellsMap safeSetObject:cellClass forKey:identifier];
}

- (WJCycleCell *)dequeueReusableCellWithIdentifier:(NSString *)identifiy {
    WJCycleCell *cycleCell = nil;
    for (WJCycleCell *cell in self.cellBufferPool) {
        // 需要健壮性判断
        if ([cell.identifiy isEqualToString:identifiy]) {
            cycleCell = cell;
            [self.cellBufferPool removeObject:cycleCell];
            break;
        }
    }
    if (!cycleCell) {
        Class cellClazz = [self.visibleCellsMap objectForKey:identifiy];
        if (cellClazz) {
            cycleCell = [[cellClazz alloc] initWithIdentifier:identifiy];
        }
    }
//    if (![self.visibleCells containsObject:cycleCell]) {
//        [self.visibleCells safeAddObject:cycleCell];
//    }
    return cycleCell;
}

- (void)reloadData {
    // 先搞死一个section
//    self.numberOfSections = 1;
//    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsIncycleView:)]) {
//        self.numberOfSections = [self.dataSource numberOfSectionsIncycleView:self];
//    }
//    WJIndexPath *firstIndex = [self.indexPathArray safeObjectAtIndex:0];
//    if (firstIndex == nil) {
//        firstIndex = [WJIndexPath indexPathWithRow:0 section:self.numberOfSections - 1];
//    }
//    int index = 0;
//    int allLength = 0;
//    for (int section = 0; section < self.numberOfSections; section++) {
//        long numberOfRowsInSection = [self.dataSource cycleView:self numberOfRowsInSection:section];
//        for (int row = 0; row < numberOfRowsInSection; row++) {
//            // 所取cell均偏移1
//            index ++;
//            WJIndexPath *indexPath = [self.indexPathArray safeObjectAtIndex:index];
//            if (indexPath == nil) {
//                indexPath = [WJIndexPath indexPathWithRow:row section:section];
//                [self.indexPathArray safeAddObject:indexPath];
//            }
//            indexPath.length = [self.dataSource cycleView:self heightForRowAtIndexPath:indexPath];
//            indexPath.offsetLength = allLength;
//            allLength += indexPath.length;
//        }
//    }
    self.indexPathArray = [NSMutableArray array];
    if ([self.dataSource respondsToSelector:@selector(cycleView:numberOfRowsInSection:)]) {
        // 不分组，起码暂时不分
        self.numberOfSections = [self.dataSource cycleView:self numberOfRowsInSection:0];
    }
    CGFloat allHeight = 0;
    for (int i = 0; i < self.numberOfSections; i++) {
        WJIndexPath *indexPath = [self.indexPathArray safeObjectAtIndex:i];
        if (indexPath == nil) {
            indexPath = [WJIndexPath indexPathWithRow:i section:0];
            [self.indexPathArray safeAddObject:indexPath];
        }
        CGFloat cellHeight = 44;
        if ([self.dataSource respondsToSelector:@selector(cycleView:heightForRowAtIndexPath:)]) {
            cellHeight = [self.dataSource cycleView:self heightForRowAtIndexPath:indexPath];
        }
        indexPath.length = cellHeight;
        indexPath.offsetLength = allHeight;
        allHeight += cellHeight;
    }
    self.allHeight = allHeight;
    
    allHeight = 0;
    NSMutableArray *supplementArray = [NSMutableArray array];
    for (long i = 0; i < self.numberOfSections; i++) {
        WJIndexPath *indexPath = [self.indexPathArray safeObjectAtIndex:i];
        WJIndexPath *supplementIndexPath = [WJIndexPath indexPathWithRow:i section:0];
        supplementIndexPath.length = indexPath.length;
        supplementIndexPath.offsetLength = self.allHeight + allHeight;
        allHeight += indexPath.length;
        [supplementArray safeAddObject:supplementIndexPath];
        if (allHeight >= self.wj_width) {    //
            break;
        }
    }
    for (WJIndexPath *indexPath in supplementArray) {
        [self.indexPathArray insertObject:indexPath atIndex:0];
    }
    [self setNeedsLayout];
}

- (void)toNextPage {
    // 重复代码，后期有时间抽出
    int cycleCount = 0;
    if (self.numberOfSections > 0) {
        cycleCount = floorf(self.bounds.origin.x / self.allHeight);
    }
    CGFloat allHeight = self.allHeight * cycleCount;
    CGRect bounds = self.bounds;
    for (WJIndexPath *indexPath in self.indexPathArray) {
        allHeight += indexPath.length;
        if (allHeight - indexPath.length <= bounds.origin.x &&
            allHeight > bounds.origin.x) {
            bounds.origin.x = allHeight;
            [UIView animateWithDuration:0.3 animations:^{
                CGRect preBounds = self.bounds;
                preBounds.origin.x = bounds.origin.x - 0.01;
                self.bounds = preBounds;
            } completion:^(BOOL finished) {
                self.bounds = bounds;
            }];
            break;
        }
    }
}

#pragma mark - private
- (void)enqueueReusableCell:(WJCycleCell *)cell {
    if (cell) {
        [cell setSelected:NO animated:NO];
        [self.cellBufferPool addObject:cell];
        if ([self.visibleCells containsObject:cell]) {
            [self.visibleCells removeObject:cell];
        }
        [cell removeFromSuperview];
    }
}

- (void)initUI {
    self.clipsToBounds = YES;
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
    [self addGestureRecognizer:_panGestureRecognizer];
    self.animator = [[UIDynamicAnimator alloc]initWithReferenceView:self];
    self.animator.delegate = self;
    self.dynamicItem = [[WJDynamicItem alloc] init];
    [self reloadData];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGestureRecognizer {
    
    switch (panGestureRecognizer.state) {
            // remove animator
        case UIGestureRecognizerStateBegan:
        {
            [self endDecelerating];
            self.tracking = YES;
            self.touchBounds = self.bounds;
            if ([self.delegate respondsToSelector:@selector(cycleViewWillDrag:)]) {
                [self.delegate cycleViewWillDrag:self];
            }
        }
            // change offset and add RubberBanding effect
        case UIGestureRecognizerStateChanged:
        {
            self.tracking = YES;
            self.dragging = YES;
            CGRect newBounds  = self.touchBounds;
            CGPoint translation = [panGestureRecognizer translationInView:self];
            
            newBounds.origin  = CGPointMake(newBounds.origin.x - translation.x, newBounds.origin.y);
            self.newBounds = newBounds;
            if ([self.delegate respondsToSelector:@selector(cycleViewDidScroll:)]) {
                [self.delegate cycleViewDidScroll:self];
            }
            
//            [panGestureRecognizer setTranslation:CGPointMake(0, translation.y) inView:self.superview];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            self.tracking = NO;
            self.dragging = NO;
            CGPoint velocity = [panGestureRecognizer velocityInView:self];
            // only support vertical
            velocity.y = 0;
            velocity.x = - velocity.x;
            if (self.pagingEnabled) {
                int cycleCount = 0;
                if (self.numberOfSections > 0) {
                    cycleCount = floorf(self.bounds.origin.x / self.allHeight);
                }
                CGFloat allHeight = self.allHeight * cycleCount;
                CGRect bounds = self.bounds;
                CGRect preBounds = self.bounds;
                for (WJIndexPath *indexPath in self.indexPathArray) {
                    allHeight += indexPath.length;
                    if (allHeight - indexPath.length <= bounds.origin.x &&
                        allHeight > bounds.origin.x) {
                        if (self.bounds.origin.x + velocity.x / 2.0 >= allHeight - indexPath.length / 2.0) {
                            bounds.origin.x = allHeight;
                            preBounds.origin.x = allHeight - 0.01;
                        } else {
                            bounds.origin.x = allHeight - indexPath.length;
                            preBounds.origin.x = allHeight - indexPath.length;
                        }
                        [UIView animateWithDuration:0.3 animations:^{
                            self.bounds = preBounds;
                        } completion:^(BOOL finished) {
                            self.bounds = bounds;
                        }];
                        break;
                    }
                }
            } else {
                self.dynamicItem.center = self.bounds.origin;
                self.decelerationBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.dynamicItem]];
                [_decelerationBehavior addLinearVelocity:velocity forItem:self.dynamicItem];
                _decelerationBehavior.resistance = 2;
                
                __weak typeof(self) weakSelf = self;
                _decelerationBehavior.action = ^{
                    CGPoint center = weakSelf.dynamicItem.center;
                    center.y       = weakSelf.bounds.origin.y;
                    CGRect bounds   = weakSelf.bounds;
                    bounds.origin   = center;
                    weakSelf.newBounds = bounds;
                };
                
                [self.animator addBehavior:_decelerationBehavior];
            }
            if ([self.delegate respondsToSelector:@selector(cycleViewDidEndDrag:)]) {
                [self.delegate cycleViewDidEndDrag:self];
            }
        }
            break;
            
        default:
        {
            self.tracking = NO;
            self.dragging = NO;
        }
            break;
    }
}

- (void)setNewBounds:(CGRect)newBounds {
    _newBounds = newBounds;
    self.bounds = newBounds;
}

- (void)endDecelerating {
    [self.animator removeAllBehaviors];
    [self setDecelerationBehavior:nil];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView * view = [super hitTest:point withEvent:event];
    BOOL isContainsPoint = NO;
    isContainsPoint = !CGRectContainsPoint(self.bounds, point);
    
    if (isContainsPoint) {
        [self endDecelerating];
    }
    else {
        if (self.isDecelerating) {
            return self;
        }
    }
    return view;
}

#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    // 布局头试图
    [self layoutHeaderView];
    // 布局cell
    [self layoutCells];
    // 布局尾试图
    [self layoutFooterView];
}

- (void)layoutHeaderView {

}

- (void)layoutCells {
    // 移除离开屏幕的cell
    [self removeLeaveScreenCell];
    // 添加即将进入屏幕的cell
    [self addEnterScreenCell];
}

- (void)layoutFooterView {
    
}

- (void)removeLeaveScreenCell {
    int cycleCount = 0;
    if (self.numberOfSections > 0) {
        cycleCount = floorf(self.bounds.origin.x / self.allHeight);
    }
    CGFloat boundsX = self.bounds.origin.x - self.allHeight * cycleCount;
    NSMutableArray *willRemoveArray = [NSMutableArray array];
    for (WJCycleCell *cell in self.visibleCells) {
        WJIndexPath *indexPath = cell.wj_indexPath;
        if (indexPath.offsetLength + indexPath.length < boundsX || indexPath.offsetLength > boundsX + kScreenWidth) {
            [willRemoveArray safeAddObject:cell];
        }
    }
    for (WJCycleCell *cell in willRemoveArray) {
        [self enqueueReusableCell:cell];
    }
}

- (void)addEnterScreenCell {
    int cycleCount = 0;
    if (self.numberOfSections > 0) {
        cycleCount = floorf(self.bounds.origin.x / self.allHeight);
    }
    CGFloat boundsX = self.bounds.origin.x - self.allHeight * cycleCount;
//    NSLog(@"boundsX:%f", boundsX);
    for (WJIndexPath *indexPath in self.indexPathArray) {
        BOOL isAlreadyShow = NO;
        for (WJCycleCell *cell in self.visibleCells) {
            WJIndexPath *visibleIndexPath = cell.wj_indexPath;
            if (visibleIndexPath == indexPath) {
                isAlreadyShow = YES;
                break;
            }
        }
        if (isAlreadyShow) continue;
        if (indexPath.offsetLength + indexPath.length >= boundsX && indexPath.offsetLength <= boundsX + kScreenWidth) {
            WJCycleCell *cell = [self.dataSource cycleView:self cellForRowAtIndexPath:indexPath];
            cell.wj_indexPath = indexPath;
            [self addSubview:cell];
            cell.wj_x = indexPath.offsetLength + self.allHeight * cycleCount;
            cell.wj_width = indexPath.length;
            cell.wj_y = 0;
            cell.wj_height = self.wj_height;
            if (![self.visibleCells containsObject:cell]) {
                [self.visibleCells safeAddObject:cell];
            }
        }
    }
}

#pragma mark - lazy
- (NSMutableArray *)cellBufferPool {
    if (!_cellBufferPool) {
        _cellBufferPool = [NSMutableArray array];
    }
    return _cellBufferPool;
}

- (NSMutableDictionary *)visibleCellsMap {
    if (!_visibleCellsMap) {
        _visibleCellsMap = [NSMutableDictionary dictionary];
    }
    return _visibleCellsMap;
}

- (NSMutableArray *)visibleCells {
    if (!_visibleCells) {
        _visibleCells = [NSMutableArray array];
    }
    return _visibleCells;
}

- (NSMutableArray *)indexPathArray {
    if (!_indexPathArray) {
        _indexPathArray = [NSMutableArray array];
    }
    return _indexPathArray;
}

@end
