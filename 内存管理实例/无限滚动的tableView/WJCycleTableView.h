//
//  WJCycleTableView.h
//  Demo
//
//  Created by 汪俊 on 2019/6/14.
//  Copyright © 2019年 sogubaby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJCycleCell.h"
@class WJCycleTableView, WJIndexPath;

/**
 *  能无限滚动的tableView
 */

@protocol WJCycleTableViewDataSource <NSObject>

@required
- (NSInteger)cycleView:(WJCycleTableView *)cycleView numberOfRowsInSection:(NSInteger)section;
- (WJCycleCell *)cycleView:(WJCycleTableView *)cycleView cellForRowAtIndexPath:(WJIndexPath *)indexPath;

@optional
- (NSInteger)numberOfSectionsIncycleView:(WJCycleTableView *)cycleView;
- (CGFloat)cycleView:(WJCycleTableView *)cycleView heightForRowAtIndexPath:(WJIndexPath *)indexPath;

@end

@protocol WJCycleTableViewDelegate <NSObject>

@optional
- (void)cycleViewDidScroll:(WJCycleTableView *)cycleView;
- (void)cycleViewWillDrag:(WJCycleTableView *)cycleView;
- (void)cycleViewDidEndDrag:(WJCycleTableView *)cycleView;

@end

@interface WJIndexPath : NSObject

+ (instancetype)indexPathWithIndex:(NSUInteger)index;
- (instancetype)initWithIndex:(NSUInteger)index;
@property (readonly) CGFloat length;
@property (readonly) NSUInteger index;
@property (readonly) NSUInteger row;
@property (readonly) NSUInteger section;

@end

@interface WJCycleTableView : UIView

@property (nonatomic, weak) id<WJCycleTableViewDataSource> dataSource;
@property (nonatomic, weak) id<WJCycleTableViewDelegate> delegate;
@property (nonatomic, readonly) NSInteger numberOfSections;
@property (nonatomic, strong, readonly) UIPanGestureRecognizer * panGestureRecognizer;
@property (nonatomic, readonly, getter=isTracking)     BOOL tracking;
@property (nonatomic, readonly, getter=isDragging)     BOOL dragging;
@property (nonatomic, readonly, getter=isDecelerating) BOOL decelerating;
@property (nonatomic, getter=isPagingEnabled)          BOOL pagingEnabled;

- (WJCycleCell *)dequeueReusableCellWithIdentifier:(NSString *)identifiy;
- (void)registerClass:(nullable Class)cellClass forCellReuseIdentifier:(NSString *)identifier;
- (void)reloadData;
- (void)toNextPage;

@end
