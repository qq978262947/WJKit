//
//  WJCycleTableViewController.m
//  内存管理实例
//
//  Created by 汪俊 on 2019/8/20.
//  Copyright © 2019年 汪俊. All rights reserved.
//

#import "WJCycleTableViewController.h"
#import "WJCycleTableView.h"

@interface WJCycleTableViewController ()
<
WJCycleTableViewDelegate,
WJCycleTableViewDataSource
>

@property (nonatomic, strong) WJCycleTableView *cycleTableView;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation WJCycleTableViewController

#pragma mark - life style
- (void)viewDidLoad {
    [super viewDidLoad];
    self.cycleTableView.backgroundColor = [UIColor blackColor];
    self.cycleTableView.pagingEnabled = YES;
    [self.cycleTableView registerClass:[WJCycleCell class] forCellReuseIdentifier:@"WJCycleCell"];
    [self.cycleTableView reloadData];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)toNextPage {
    [self.cycleTableView toNextPage];
}

#pragma mark - WJCycleTableViewDataSource & WJCycleTableViewDelegate
- (void)cycleViewDidScroll:(WJCycleTableView *)cycleView {
    
}

- (void)cycleViewWillDrag:(WJCycleTableView *)cycleView {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)cycleViewDidEndDrag:(WJCycleTableView *)cycleView {
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (NSInteger)cycleView:(WJCycleTableView *)cycleView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (WJCycleCell *)cycleView:(WJCycleTableView *)cycleView cellForRowAtIndexPath:(WJIndexPath *)indexPath {
    WJCycleCell *cell = [cycleView dequeueReusableCellWithIdentifier:@"WJCycleCell"];
    cell.titleLabel.text = [NSString stringWithFormat:@"%li", indexPath.row];
    NSArray *imageArray = @[@"minion_01", @"minion_02", @"minion_03", @"minion_01", @"minion_03", @"minion_02"];
    NSString *imageName = [imageArray safeObjectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:imageName];
    if (indexPath.row == 0) {
        cell.backgroundColor = [UIColor greenColor];
    } else if (indexPath.row == 1) {
        cell.backgroundColor = [UIColor blueColor];
    } else if (indexPath.row == 2) {
        cell.backgroundColor = [UIColor orangeColor];
    } else if (indexPath.row == 3) {
        cell.backgroundColor = [UIColor yellowColor];
    } else {
        cell.backgroundColor = [UIColor redColor];
    }
    return cell;
}

- (CGFloat)cycleView:(WJCycleTableView *)cycleView heightForRowAtIndexPath:(WJIndexPath *)indexPath {
    return kScreenWidth;
}

#pragma mark - getter methods
- (WJCycleTableView *)cycleTableView {
    if (!_cycleTableView) {
        _cycleTableView = [WJCycleTableView new];
        _cycleTableView.frame = CGRectMake(0, 100, kScreenWidth, 150);
        [self.view addSubview:_cycleTableView];
        _cycleTableView.dataSource = self;
        _cycleTableView.delegate = self;
    }
    return _cycleTableView;
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(toNextPage) userInfo:nil repeats:YES];
    }
    return _timer;
}

@end
