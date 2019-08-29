//
//  DemoListTableVC.m
//  内存管理实例
//
//  Created by 汪俊 on 2018/4/28.
//  Copyright © 2018年 汪俊. All rights reserved.
//

#import "DemoListTableVC.h"
#import "DemoConfigurationModel.h"
#import "WaterRippleView.h"
#import "内存管理实例-Swift.h"
#import "TestSwipeTableViewVC.h"
#import "WJRefresh.h"

@interface DemoListTableVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, weak) UITableView *tableView;

@end

@implementation DemoListTableVC
static NSString *cellIdentifier = @"DemoListTableVC";

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
}

#pragma mark - overwrite

#pragma mark - public

#pragma mark - UITableViewDelegate and UITabelViewDateSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    DemoConfigurationModel *configurationModel = self.dataArray[indexPath.row];
    cell.textLabel.text = configurationModel.demoItemTitleName;
    cell.textLabel.textColor = [UIColor colorWithRed:67.0f/255.0 green:133.0f/255.0 blue:245.0f/255.0 alpha:1.0];;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DemoConfigurationModel *demoConfigurationModel = self.dataArray[indexPath.row];
    if (demoConfigurationModel.demoItemNextPageArray.count > 0) {
        [self goNextPageWithDataArray:demoConfigurationModel.demoItemNextPageArray title:demoConfigurationModel.demoItemTitleName];
    } else if (demoConfigurationModel.demoItemMethodNameBlock) {
        demoConfigurationModel.demoItemMethodNameBlock(demoConfigurationModel.demoItemTitleName);
    } else {
        if (demoConfigurationModel.demoItemClassName != nil && [demoConfigurationModel.demoItemClassName isKindOfClass:[NSString class]] && ![demoConfigurationModel.demoItemClassName isEqualToString:@""]) {
            UIViewController *demoVC = [[NSClassFromString(demoConfigurationModel.demoItemClassName) alloc]init];
            if (demoVC) {
                demoVC.view.backgroundColor = [UIColor whiteColor];
                demoVC.title = demoConfigurationModel.demoItemTitleName;
                [self.navigationController pushViewController:demoVC animated:YES];
            }
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - XXX notification

#pragma mark - event response


#pragma mark - private
- (void)goNextPageWithDataArray:(NSArray *)dataArray title:(NSString *)title {
    DemoListTableVC *listTableVC = [[DemoListTableVC alloc]init];
    listTableVC.title = title;
    listTableVC.dataArray = dataArray;
    [self.navigationController pushViewController:listTableVC animated:YES];
}

#pragma mark - getter and setter

// 将代码集中到一起，添加删除都特别方便。定位的时候一目了然。
// 内部代码拆出去不会使数据源代码过于庞大，定位还是只需要在数据源中一眼找到对应的方法，只需要管理这一处就好。
////////////////////////////////////////////////////////////////////////////////////////// 第一页
- (NSArray *)dataArray {
    if (_dataArray == nil) {
        __weak typeof(self) weakSelf = self;
        _dataArray = @[
                       [DemoConfigurationModel configurationModelWithDemoItemTitleName:@"引用计数" demoItemNextPageArray:[self memoryDataArray]],
                       [DemoConfigurationModel configurationModelWithDemoItemTitleName:@"block" demoItemNextPageArray:[self blockDataArray]],
                       [DemoConfigurationModel configurationModelWithDemoItemTitleName:@"TestRuntimeVC" demoItemClassName:@"TestRuntimeVC"],
                       [DemoConfigurationModel configurationModelWithDemoItemTitleName:@"WJCycleTableViewController" demoItemClassName:@"WJCycleTableViewController"],
                       [DemoConfigurationModel configurationModelWithDemoItemTitleName:@"SwipeTableView" demoItemClassName:@"TestSwipeTableViewVC"],
                       [DemoConfigurationModel configurationModelWithDemoItemTitleName:@"Swift-SwipeTableView" demoItemMethodNameBlock:^(NSString *title) {
                           TestSwiftSwipeTableViewVC *dataVC = [TestSwiftSwipeTableViewVC new];
                           dataVC.view.backgroundColor = [UIColor whiteColor];
                           [weakSelf.navigationController pushViewController:dataVC animated:YES];
                       }],
                       [DemoConfigurationModel configurationModelWithDemoItemTitleName:@"崩溃测试" demoItemMethodNameBlock:^(NSString *title) {
                           EditNameOrNicknameVC *editVC = [EditNameOrNicknameVC editNameVCWithInputString:@"123123"];
                           editVC.weakDelegate = self;
                           [self.navigationController pushViewController:editVC animated:YES];
                       }],
                       [DemoConfigurationModel configurationModelWithDemoItemTitleName:@"下拉刷新" demoItemMethodNameBlock:^(NSString *title) {
                           [weakSelf.tableView refreshHeaderWithRefreshingBlock:^(WJRefreshHeader *header) {
                               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                   [weakSelf.tableView.wj_header endRefreshing];
                               });
                           }];
                       }],
//                       [DemoConfigurationModel configurationModelWithDemoItemTitleName:@"swift" demoItemMethodNameBlock:^(NSString *title) {
//                           ShowSwiftDataVC *dataVC = [ShowSwiftDataVC new];
//                           [weakSelf.navigationController pushViewController:dataVC animated:YES];
//                       }]
                 ];
    }
    return _dataArray;
}

////////////////////////////////////////////////////////////////////////////////////////// 第二页
- (NSArray *)memoryDataArray {
    return @[
             [DemoConfigurationModel configurationModelWithDemoItemTitleName:@"内存管理图" demoItemClassName:@"ShowAboutVC"],
             [DemoConfigurationModel configurationModelWithDemoItemTitleName:@"内存管理原则" demoItemClassName:@"MemoryManagementRulesController"],
             [DemoConfigurationModel configurationModelWithDemoItemTitleName:@"引用计数数值" demoItemClassName:@"ReferenceCountVC"],
             [DemoConfigurationModel configurationModelWithDemoItemTitleName:@"ARC修饰符" demoItemNextPageArray:[self memoryOwnershipArray]],
             [DemoConfigurationModel configurationModelWithDemoItemTitleName:@"关键数比较" demoItemClassName:@"AttributesCompareVC"],
             [DemoConfigurationModel configurationModelWithDemoItemTitleName:@"自动释放池探索研究" demoItemNextPageArray:[self memoryAutoreleasePoolArray]]
             ];
}

- (NSArray *)blockDataArray {
    return @[
             [DemoConfigurationModel configurationModelWithDemoItemTitleName:@"截获对象" demoItemClassName:@"InterceptedObjectsVC"],
             [DemoConfigurationModel configurationModelWithDemoItemTitleName:@"截取变量" demoItemClassName:@"InterceptedVariableVC"],
             [DemoConfigurationModel configurationModelWithDemoItemTitleName:@"Block_Copy对引用计数影响" demoItemClassName:@"InterceptedObjectsMRCVC"],
             [DemoConfigurationModel configurationModelWithDemoItemTitleName:@"block变量存储区域和对象修饰符" demoItemClassName:@"BlockVariableVC"],
             [DemoConfigurationModel configurationModelWithDemoItemTitleName:@"Block存储区域" demoItemNextPageArray:[self blockStoreDataArray]],
             [DemoConfigurationModel configurationModelWithDemoItemTitleName:@"block例题" demoItemNextPageArray:[self blockExampleDataArray]],
             [DemoConfigurationModel configurationModelWithDemoItemTitleName:@"block内部实现" demoItemClassName:@"BlockAchieveVC"],
             [DemoConfigurationModel configurationModelWithDemoItemTitleName:@"Block语法" demoItemClassName:@"BlockSyntaxVC"]
             ];
}

////////////////////////////////////////////////////////////////////////////////////////// 第三页
- (NSArray *)memoryAutoreleasePoolArray {
    return @[
             [DemoConfigurationModel configurationModelWithDemoItemTitleName:@"MRC环境下研究autorealease" demoItemClassName:@"MRCAutoReleaseViewController"],
             [DemoConfigurationModel configurationModelWithDemoItemTitleName:@"ARC环境下研究autorealease" demoItemClassName:@"ARCAutoReleaseViewController"],
             [DemoConfigurationModel configurationModelWithDemoItemTitleName:@"自动释放池内存" demoItemClassName:@"AutoReleaseMemoryViewController"]
             ];
    
}

// - memoryDataArray下
- (NSArray *)memoryOwnershipArray {
    return @[
             [DemoConfigurationModel configurationModelWithDemoItemTitleName:@"__strong" demoItemClassName:@"ARCOwnershipAutoStrongVC"],
             [DemoConfigurationModel configurationModelWithDemoItemTitleName:@"__weak" demoItemClassName:@"ARCOwnershipAutoWeakVC"],
             [DemoConfigurationModel configurationModelWithDemoItemTitleName:@"__unsafe__unretained" demoItemClassName:@"ARCOwnershipAutoUnRetainedVC"],
             [DemoConfigurationModel configurationModelWithDemoItemTitleName:@"__autoreleasing" demoItemClassName:@"ARCOwnershipAutoReleaseVC"]
             ];
}

// - blockDataArray下
- (NSArray *)blockStoreDataArray {
    return @[
             [DemoConfigurationModel configurationModelWithDemoItemTitleName:@"ARC" demoItemClassName:@"BlockStorageARCVC"],
             [DemoConfigurationModel configurationModelWithDemoItemTitleName:@"MRC" demoItemClassName:@"BlockStorageMRCVC"]
             ];
}

- (NSArray *)blockExampleDataArray {
    return @[
             [DemoConfigurationModel configurationModelWithDemoItemTitleName:@"ARC" demoItemClassName:@"ExampleBlockARCVC"],
             [DemoConfigurationModel configurationModelWithDemoItemTitleName:@"MRC" demoItemClassName:@"ExampleBlockMRCVC"]
             ];
}

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 200) style:UITableViewStylePlain];
        _tableView = tableView;
        [self.view addSubview:tableView];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor whiteColor];
        
        WaterRippleView *waterRippleView = [[WaterRippleView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 200, self.view.bounds.size.width, 200)];
        [self.view addSubview:waterRippleView];
        waterRippleView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

#pragma mark - EditNameOrNicknameVCDelegate
- (void)editNameOrNicknameVCDidClickSaveWithInputString:(NSString *)inputString editType:(enum EditVCType)editType {
//    BasicTableViewCell *currentCell = self.currentCell;
//    if (currentCell != nil) {
//        currentCell.detailTextField.text = inputString;
//        if (editType == EditVCTypeName) {
//            self.myBasicInfoVM.teacherBaseInfoNew.realName = inputString;
//        } else if (editType == EditVCTypeNickName) {
//            self.myBasicInfoVM.teacherBaseInfoNew.nickName = inputString;
//        }
//        [self saveData];
//    }
}

@end
