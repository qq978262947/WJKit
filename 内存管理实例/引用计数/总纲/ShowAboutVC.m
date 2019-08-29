//
//  ShowAboutVC.m
//  内存管理实例
//
//  Created by 汪俊 on 2018/5/2.
//  Copyright © 2018年 汪俊. All rights reserved.
//

#import "ShowAboutVC.h"

@interface ShowAboutVC () <UIScrollViewDelegate> // <UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ShowAboutVC

#pragma mark - life style
- (void)viewDidLoad {
    [super viewDidLoad];
//    NSString *cachePath = @"/others/内存管理.xmind";
//    UIDocumentInteractionController *documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:cachePath]];
//    documentController.delegate = self;
//    [documentController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];

//    {
//        id __weak obj1 = obj;
//        NSLog(@"%@", obj1);
//    }
//    该源代码可转换为如下形式：
//    /* 编译器的模拟代码 */
//    id obj1;
//    objc_initWeak(&obj1, obj);
//    id tmp = objc_loadWeakRetained(&obj1);
//    objc_autorelease(tmp);
//    NSLog(@"%@", tmp);
//    objc_destoryWeak(&obj1);
//    与赋值相比，在使用附有__weak修饰符的情形下，增加了对objc_loadWeakRetained函数和objc_autorelease函数的调用。这些函数动作如下。
//    （1）objc_loadWeakRetained函数取出附有__weak修饰符变量所引用的对象并retain
//    （2）objc_autorelease函数将对象注册到autoreleasepool中
    // 初始化当前的视图
    [self setupCurrentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private
- (void)setupCurrentView {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 添加一个背景 - 可放大
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    // 最大倍数
    scrollView.maximumZoomScale = 15.0;
    // 最小倍数
    scrollView.minimumZoomScale = 1.0;
    scrollView.zoomScale = 1.2;
    scrollView.delegate = self;
    
    // 添加一个需要放大图片的持有视图
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 770, 720)];
    _imageView = imageView;
    [scrollView addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"ShowMemory.png"];
    
    // scrollview的滑动边界
    scrollView.contentSize = CGSizeMake(770, 720);
    
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // 需要放大的视图
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // 已经正在放大
}

//#pragma mark - UIDocumentInteractionControllerDelegate
//- (void)documentInteractionController:(UIDocumentInteractionController *)controller willBeginSendingToApplication:(nullable NSString *)application {
//
//}
//
//- (void)documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(nullable NSString *)application {
//
//}
//
//- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller {
//
//}

@end
