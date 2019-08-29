//
//  WJSwipeTableView.swift
//  内存管理实例
//
//  Created by 汪俊 on 2018/5/18.
//  Copyright © 2018年 汪俊. All rights reserved.
//

import UIKit

// - 暂时不考虑封装的问题，以及代码的高聚合低耦合等 - 后面会优化
// 1. 先添加delegate 和 datasource （后面必然需要）
// 2. 然后创建头部的视图
// 3. 动手时 - 第一个 需要做的是实现一个联动效果


// 已经实现了需要的功能 - bug先不看，优化后面寻找
// 然后抽离接口 headerview segmentview 对应的那些tableview。那些tableview就不弄成自定义的tableView了。可以用collectionview，觉得浪费把tableview转90度也一样

//isHiddenNavagatinBar
@objc protocol WJSwipeTableViewDelegate {
    @objc optional func swipeTableViewIsHiddenNavagatinBar(swipeTableView: WJSwipeTableView, isHiddenNavagatinBar: Bool)
    @objc optional func swipeTableViewDidScroll(swipeTableView: WJSwipeTableView, scrollView: UIScrollView)
    @objc optional func swipeTableViewDidEndScrollingAnimation(swipeTableView: WJSwipeTableView, scrollView: UIScrollView, index: Int)
    @objc optional func swipeTableViewDidEndDecelerating(swipeTableView: WJSwipeTableView, scrollView: UIScrollView, index: Int)
}

class WJSwipeTableView: UIView {
    
    @objc weak var weakDelegate: WJSwipeTableViewDelegate?

    var isScrollingItem: Bool! = false // 是否正在滚动当前的tableview
    var currentIndex: Int! = 0
    var navBarHeight: CGFloat!
    
    var screenWidth:CGFloat =  UIScreen.main.bounds.size.width  //[UIScreen mainScreen].bounds.size.width
    var screenHeight:CGFloat = UIScreen.main.bounds.size.height
    var bgView: UIView!
    var _headerView: WJHeaderView!
    var headerView: WJHeaderView! {
        set {
            if (_headerView != newValue) {
                if (_headerView != nil) {
                    _headerView.removeFromSuperview()
                }
                _headerView = newValue
                if (_headerView != nil) {
                    _headerView.weakDelegate = self
                    self.bgView.addSubview(_headerView)
                }
                self.resetHeight()
            }
        }
        get {
            return _headerView
        }
    }
    
    var _segmentView: WJSegmentView!
    var segmentView: WJSegmentView! {
        set {
            if (_segmentView != newValue) {
                if (_segmentView != nil) {
                    _segmentView.removeFromSuperview()
                }
                _segmentView = newValue
                if (_segmentView != nil) {
                    _segmentView.weakDelegate = self
                    self.addSubview(_segmentView)
                }
                self.resetHeight()
            }
        }
        get {
            return _segmentView
        }
    }
    var scrollView: UIScrollView!
    var _dataArray: NSArray!
    var dataArray: NSArray! {
        set {
            if (_dataArray != newValue) {
                if (_dataArray != nil && _dataArray.isKind(of: NSArray.self) && _dataArray.count > 0) {
                    for tableView in _dataArray {
                        (tableView as AnyObject).removeObserver(self, forKeyPath: "contentOffset")
                        (tableView as AnyObject).removeObserver(self, forKeyPath: "contentSize")
                        (tableView as AnyObject).removeObserver(self, forKeyPath: "panGestureRecognizer.state")
                        (tableView as AnyObject).removeFromSuperview()
                    }
                }
                _dataArray = newValue
                if (_dataArray != nil && _dataArray.isKind(of: NSArray.self) && _dataArray.count > 0) {
                    let options = NSKeyValueObservingOptions.new.union(.old)
                    for i in 0..._dataArray.count - 1 {
                        let tableView = _dataArray[i] as! UITableView
                        scrollView.addSubview(tableView)
                        (tableView as AnyObject).addObserver(self, forKeyPath: "contentOffset", options: options , context:&SwipeTableViewContentOffsetContext)
                        (tableView as AnyObject).addObserver(self, forKeyPath: "contentSize", options: options , context:&SwipeTableViewContentSizeContext)
                        (tableView as AnyObject).addObserver(self, forKeyPath: "panGestureRecognizer.state", options: options , context:&SwipeTableViewPanGestureContext)
                        tableView.frame = CGRect(x: CGFloat(i) * scrollView.bounds.size.width, y: 0, width: scrollView.bounds.size.width, height: scrollView.bounds.size.height)
                    }
                     scrollView.contentSize = CGSize(width: CGFloat(self.dataArray.count) * screenWidth, height: 0)
                }
            }
        }
        get {
            return _dataArray
        }
    }
    
    
    lazy var btnsArray: NSMutableArray! = NSMutableArray.init()
    var SwipeTableViewContentOffsetContext = UnsafeMutablePointer<Int>(bitPattern: 1)
    var SwipeTableViewContentSizeContext = UnsafeMutablePointer<Int>(bitPattern: 2)
    var SwipeTableViewPanGestureContext = UnsafeMutablePointer<Int>(bitPattern: 3)
    
    static func swipeTableViewWithFrame(frame: CGRect) -> WJSwipeTableView {
        let swipeTableView = WJSwipeTableView.init(frame: frame)
        swipeTableView.initView() // 先不考虑手动赋frame的情况
        return swipeTableView
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initView()
    }

    deinit {
        for vc in self.dataArray {
            (vc as AnyObject).view.removeObserver(self, forKeyPath: "contentOffset")
            (vc as AnyObject).view.removeObserver(self, forKeyPath: "contentSize")
            (vc as AnyObject).view.removeObserver(self, forKeyPath: "panGestureRecognizer.state")
        }
    }
    
    @objc func setSegmentIndex(index :Int) {
        // 让底部的内容scrollView滚动到对应位置
        self.currentIndex = index
        var offset = self.scrollView.contentOffset
        offset.x = CGFloat(index) * self.scrollView.bounds.size.width
        self.scrollView.setContentOffset(offset, animated: true)
        let segmentY = self.headerView.frame.size.height - self.bgView.bounds.origin.y
        if (segmentY > self.navBarHeight) {
            if (self.dataArray != nil && self.dataArray.count > index) {
                let tableView = self.dataArray[index] as! UITableView
                tableView.contentOffset = CGPoint(x: tableView.contentOffset.x, y: 0)
            }
        }
    }
}


// 1. 先不管SwipeTableView的那一套实现 （按自己的思路来，最后相互印证）
// 2. 开始尝试写 - 理清思路
//      2.1 也是头部一个view添加滑动手势，那些控件的父试图和自定义的segment同一层级，改父视图的bounds自定义的segment放另一个视图，移动父试图的bounds的同时更改自定义的segment
//      2.2 当自定义的segment超出的时候，只改变父试图的bounds
//      2.3 滑动内部的tableview的时候，监控偏移量，判断是否需要更改父试图的bounds
//      2.4 滑动segment或headerview的时候更改父试图的bounds
// 思路就是这样 - 回弹等细节问题不能阻塞思路 - 后面优化 - 考虑了一下，还是用swift写一个的好
// 3. 基本已经实现了，回弹也加上去了。但是有几个问题
//      3.1 segmentView和headerView类似就没弄了，可以抽取一个公共基类 - 已抽取
//      3.2 回弹只是用了一个动画来处理 - 实际上可能并不太合适 - 暂不处理
//      3.1 有时候上拉或下拉tableview时会没拉动，是个bug - 已解决
// 4. 未集成下拉刷新
//      4.1 下拉刷新实际上是在顶上加一个刷新控件，监控scrollview的偏移量
//      4.2 但是所用的是view，所以只能读懂刷新控件全部原理，然后加以添加
private extension WJSwipeTableView {
    func initView() {
        // 初始化数据
        self.setupData()
        // 背景视图（存放头部和scrollview的）
        self.initContentView()
        // 存放segmentview的
        self.initSegmentView()
        // resetHeight
        self.resetHeight()
    }
    
    func setupData() {
//        ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//        let isIponeX: Bool = __CGSizeEqualToSize(CGSize(width: 1125, height: 2436), UIScreen.main.currentMode!.size)
        self.navBarHeight = self.isIphoneX() ? 88: 64
    }
    
    func isIphoneX() -> Bool {
        var iPhoneX: Bool = false
        if (UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.phone) {
            return iPhoneX
        }
        if #available(iOS 11.0, *) {
            // iOS 11 及其以上系统运行
            let mainWindow = UIApplication.shared.delegate?.window as? UIWindow
            if (mainWindow?.safeAreaInsets.bottom ?? 0.0 > CGFloat(0.0)) {
                iPhoneX = true
            }
        }
        return iPhoneX
    }
//    + (BOOL)isPhoneX {
//    BOOL iPhoneX = NO;
//    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {//判断是否是手机
//    return iPhoneX;
//    }
//    if (@available(iOS 11.0, *)) {
//    UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
//    if (mainWindow.safeAreaInsets.bottom > 0.0) {
//    iPhoneX = YES;
//    }
//    }
//    return iPhoneX;
//    }
    
    func initContentView() {
        // 内容的背景视图
        self.initBackgroundView()
        // 头部
        self.initHeaderView()
        // scrollView
        self.initScrollView()
    }
    
    func initBackgroundView() {
        let bgView = UIView.init()
        self.bgView = bgView
        bgView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight + 300 + 44)
        bgView.backgroundColor = UIColor.white
        self.addSubview(bgView)
    }
    
    func initHeaderView() {
        let headerImage = UIImage.init(named: "onepiece_kiudai")
        let headerImageH = screenWidth * ((headerImage?.size.height)!/(headerImage?.size.width == 0 ? screenWidth : (headerImage?.size.width)!))
        let headerView = WJHeaderView.headerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: headerImageH))//init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: headerImageH))
        _headerView = headerView
        headerView.weakDelegate = self
        headerView.backgroundColor = UIColor.white
        self.bgView.addSubview(headerView)
        
        let headerImageView = UIImageView.init()
        headerImageView.frame = CGRect(x: 0, y: 0, width: headerView.frame.size.width, height: headerView.frame.size.height)
        headerView.addSubview(headerImageView)
        headerImageView.image = headerImage
    }
    
    func initScrollView() {
        let scrollView = UIScrollView.init(frame: CGRect(x: 0, y: self.headerView.frame.size.height + 44, width: screenWidth, height: screenHeight - self.navBarHeight - 44))
        scrollView.delegate = self
        self.scrollView = scrollView
        scrollView.backgroundColor = UIColor.white
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        self.bgView.addSubview(scrollView)
    }
    
    func initSegmentView() {
        let segmentView = WJSegmentView.segmentView(frame: CGRect(x: 0, y: self.headerView.frame.size.height, width: screenWidth, height: 44))
        _segmentView = segmentView
        segmentView.weakDelegate = self
        segmentView.backgroundColor = UIColor.orange
        self.addSubview(segmentView)
        
//        self.btnsArray.removeAllObjects()
//        let count = self.dataArray.count - 1
//        let btnWidth = segmentView.bounds.size.width / CGFloat(self.dataArray.count)
//        for i in 0...count {
//            let btn = UIButton(type: UIButtonType.custom)
//            segmentView .addSubview(btn)
//            btn.frame = CGRect(x: CGFloat(i) * btnWidth, y: 0, width: btnWidth, height: segmentView.bounds.size.height - self.indicatesViewHeight)
//            btn.setTitle((self.titleArray[i] as! String), for: UIControlState.normal)
//            btn.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
//            btn.setTitleColor(UIColor(red: 67.0/255.0, green: 133.0/255.0, blue: 245.0/255.0, alpha: 1.0), for: UIControlState.highlighted)
//            btn.setTitleColor(UIColor(red: 67.0/255.0, green: 133.0/255.0, blue: 245.0/255.0, alpha: 1.0), for: UIControlState.selected)
//            btn.tag = i
//            btn.addTarget(self, action: #selector(self.didClickBtn(btn:)), for: UIControlEvents.touchUpInside)
//            self.btnsArray.add(btn)
//            if (i == count) {
//                self.lastButton = btn
//            }
//        }
//
//        let indicatesView = UIView()
//        indicatesView.frame = CGRect(x: self.kIndicatorLeftProportion * btnWidth, y: segmentView.bounds.size.height - self.indicatesViewHeight, width: btnWidth * self.kIndicatorWidthProportion, height: self.indicatesViewHeight)
//        indicatesView.backgroundColor = UIColor(red: 67.0/255.0, green: 133.0/255.0, blue: 245.0/255.0, alpha: 1.0)
//        segmentView.addSubview(indicatesView)
//        self.indicatesView = indicatesView
//        if (self.btnsArray.count > 0) {
//            self.didClickBtn(btn: self.btnsArray[0] as! UIButton)
//        }
    }
    
    // 已经实现了基本的滑动 - 接下来试试添加tableview后的滑动
    func topViewDidiPan(newBounds: CGRect, moveViewType: MoveViewType) {
        let segmentY = self.headerView.frame.size.height - newBounds.origin.y
        if (segmentY <= self.navBarHeight) { // 暂时不考虑适配，写死便于理解
            self.segmentView.frame = CGRect(x: newBounds.origin.x, y: self.navBarHeight, width: self.segmentView.bounds.size.width, height: self.segmentView.bounds.size.height)
            self.bgView.bounds = CGRect(x: newBounds.origin.x, y: self.headerView.frame.size.height - self.navBarHeight, width: newBounds.size.width, height: newBounds.size.height)
        } else if (newBounds.origin.y < 0) {
            // 下拉
            let moveView = (moveViewType == .header ? self.headerView : self.segmentView)
            var newBoundsOrginY = newBounds.origin.y
            let newOffsetY = (moveView?.oldBounds?.origin.y)! - newBoundsOrginY
            let maxFrameOrginY = self.scrollView.contentSize.height + self.navBarHeight
            let minFrameOrginY = 0.0
            // 这里面永远取的是两个边界以内的值
            let constrainedOrignY = fmax(Double(minFrameOrginY), fmin(Double(newBounds.origin.y), Double(maxFrameOrginY)))
            let rubberBandedRate = self.rubberBandRate(offset: Float(self.bgView.bounds.origin.y) + Float(constrainedOrignY))
            newBoundsOrginY = (moveView?.oldBounds?.origin.y)! - newOffsetY * CGFloat(rubberBandedRate)
            self.segmentView.frame = CGRect(x: newBounds.origin.x, y: self.headerView.frame.size.height - newBoundsOrginY, width: self.segmentView.bounds.size.width, height: self.segmentView.bounds.size.height)
            self.bgView.bounds = CGRect(x: newBounds.origin.x, y: newBoundsOrginY, width: newBounds.size.width, height: newBounds.size.height)
        } else {
            if (segmentY > self.navBarHeight) {
                let tableView = self.dataArray[self.currentIndex] as! UITableView
                if (tableView.contentOffset.y != 0) {
                    tableView.contentOffset = CGPoint(x: 0, y: 0)
                }
                
            }
            self.segmentView.frame = CGRect(x: newBounds.origin.x, y: segmentY, width: self.segmentView.bounds.size.width, height: self.segmentView.bounds.size.height)
            self.bgView.bounds = newBounds
        }
        var isHiddenNavagatinBar = true
        if (segmentY - 10.0 < self.navBarHeight) {
             isHiddenNavagatinBar = false
        }
        self.weakDelegate?.swipeTableViewIsHiddenNavagatinBar!(swipeTableView: self, isHiddenNavagatinBar: isHiddenNavagatinBar)
    }

    func resetHeight() {
        if (self.headerView != nil) {
            self.headerView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: self.headerView.frame.size.height)
            if (self.segmentView != nil) {
                self.segmentView.frame = CGRect(x: 0, y: self.headerView.frame.size.height, width: screenWidth, height: self.segmentView.frame.size.height)
                self.bgView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight + self.headerView.frame.size.height + self.segmentView.frame.size.height)
                self.scrollView.frame = CGRect(x: 0, y: self.headerView.frame.size.height + self.segmentView.frame.size.height, width: screenWidth, height: screenHeight - self.navBarHeight - self.segmentView.frame.size.height)
            }
        }
    }
}

extension WJSwipeTableView {
    
    override internal func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let newBounds = self.bgView.bounds
        let segmentY = self.headerView.frame.size.height - newBounds.origin.y
        if (context == &SwipeTableViewContentOffsetContext) {
            if (!(change?.keys.contains(NSKeyValueChangeKey.newKey))!) {
                super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
                return
            }
            let newPoint = change?[NSKeyValueChangeKey.newKey] as! CGPoint
            let newOffsetY = newPoint.y
            let tableView = self.dataArray[self.currentIndex] as! UITableView
            var isHiddenNavagatinBar = true
            if (segmentY <= self.navBarHeight) {
                if (newOffsetY >= 0) {
                    isHiddenNavagatinBar = false
                    self.segmentView.frame = CGRect(x: newBounds.origin.x, y: self.navBarHeight, width: self.segmentView.bounds.size.width, height: self.segmentView.bounds.size.height)
                    self.bgView.bounds = CGRect(x: newBounds.origin.x, y: self.headerView.frame.size.height - self.navBarHeight, width: newBounds.size.width, height: newBounds.size.height)
                } else {
                    self.segmentView.frame = CGRect(x: newBounds.origin.x, y: segmentY, width: self.segmentView.bounds.size.width, height: self.segmentView.bounds.size.height)
                    self.bgView.bounds = CGRect(x: newBounds.origin.x, y: newBounds.origin.y + newOffsetY, width: newBounds.size.width, height: newBounds.size.height)
                    if (tableView.contentOffset.y == 0) {
                        return
                    }
                    tableView.contentOffset = CGPoint(x: 0, y: 0)
                }
            } else if (segmentY > self.navBarHeight && segmentY < self.headerView.frame.size.height) { // 暂时不考虑适配，写死便于理解
                self.segmentView.frame = CGRect(x: newBounds.origin.x, y: segmentY, width: self.segmentView.bounds.size.width, height: self.segmentView.bounds.size.height)
                self.bgView.bounds = CGRect(x: newBounds.origin.x, y: newBounds.origin.y + newOffsetY, width: newBounds.size.width, height: newBounds.size.height)
                if (tableView.contentOffset.y == 0) {
                    return
                }
                tableView.contentOffset = CGPoint(x: 0, y: 0)
                
            } else if (segmentY >= self.headerView.frame.size.height) { // 下拉回弹暂时不考虑 - 考虑上拉滑动
                if (newOffsetY > 0) {
                    if (tableView.contentOffset.y >= 0) {
                        self.segmentView.frame = CGRect(x: newBounds.origin.x, y: segmentY, width: self.segmentView.bounds.size.width, height: self.segmentView.bounds.size.height)
                        self.bgView.bounds = CGRect(x: newBounds.origin.x, y: newBounds.origin.y + newOffsetY, width: newBounds.size.width, height: newBounds.size.height)
                        if (tableView.contentOffset.y == 0) {
                            return
                        }
                        tableView.contentOffset = CGPoint(x: tableView.contentOffset.x, y: 0)
//                        self.headerView.setEndNewBounds(bounds: self.bgView.bounds)
                    }
                } else {
                    if (self.isScrollingItem) {
                        // 下拉
                        var newBoundsOrginY = newBounds.origin.y + newOffsetY
                        let maxFrameOrginY = self.scrollView.contentSize.height + self.navBarHeight
                        let minFrameOrginY = 0.0
                        // 这里面永远取的是两个边界以内的值
                        let constrainedOrignY = fmax(Double(minFrameOrginY), fmin(Double(newBounds.origin.y + newOffsetY), Double(maxFrameOrginY)))
                        // oldBounds.origin.x - translation.x - constrainedOrignX 的值 保证了边界内都是0
                        let rubberBandedRate = self.rubberBandRate(offset: Float(newBounds.origin.y) + Float(newOffsetY) + Float(constrainedOrignY))
                        newBoundsOrginY = newBounds.origin.y + newOffsetY * CGFloat(rubberBandedRate)
                        self.segmentView.frame = CGRect(x: newBounds.origin.x, y: self.headerView.frame.size.height - newBoundsOrginY, width: self.segmentView.bounds.size.width, height: self.segmentView.bounds.size.height)
                        self.bgView.bounds = CGRect(x: newBounds.origin.x, y: newBoundsOrginY, width: newBounds.size.width, height: newBounds.size.height)
                        if (tableView.contentOffset.y == 0) {
                            return
                        }
                        tableView.contentOffset = CGPoint(x: tableView.contentOffset.x, y: 0)
                    } else {
                        self.segmentView.frame = CGRect(x: newBounds.origin.x, y: self.headerView.frame.size.height, width: self.segmentView.bounds.size.width, height: self.segmentView.bounds.size.height)
                        self.bgView.bounds = CGRect(x: newBounds.origin.x, y: 0, width: newBounds.size.width, height: newBounds.size.height)
                    }
                }
            }
            self.weakDelegate?.swipeTableViewIsHiddenNavagatinBar!(swipeTableView: self, isHiddenNavagatinBar: isHiddenNavagatinBar)
        } else if (context == &SwipeTableViewPanGestureContext) {
            // 当偏移量改变时记录最大值
            let states: UIGestureRecognizerState = UIGestureRecognizerState(rawValue: change?[NSKeyValueChangeKey.newKey] as! Int)!
            // 回弹
            switch states {
            case .began:
                self.isScrollingItem = true
                self.moveViewDidBeganMove(moveView: self.headerView)
                break
            case .ended:
                self.isScrollingItem = false
                self.boundsGoBack(segmentY: segmentY, newBounds: newBounds)
                break
            default:
                break
            }
        } else {
            
        }
    }
    
    func rubberBandRate(offset: Float) -> Float {
        let constant: Float = 0.15
        let dimension: Float = 10.0
        let startRate: Float = 1.0
        let result = dimension * startRate / (dimension + constant * fabs(offset))
        return result
    }
    
    func updateScrollviewContent(_ scrollView: UIScrollView) {
        // 一些临时变量
        let width = self.screenWidth
        let offsetX = scrollView.contentOffset.x

        // 当前位置需要显示的控制器的索引
        self.currentIndex = Int(offsetX / width)
    }
    
    func boundsGoBack(segmentY: CGFloat,newBounds: CGRect) {
        if (segmentY > self.headerView.frame.size.height) {
            UIView.animate(withDuration: 0.3, animations: {
                self.segmentView.frame = CGRect(x: newBounds.origin.x, y: self.headerView.bounds.size.height, width: self.segmentView.bounds.size.width, height: self.segmentView.bounds.size.height)
                self.bgView.bounds = CGRect(x: newBounds.origin.x, y: 0, width: newBounds.size.width, height: newBounds.size.height)
            }) { _ in
                self.segmentView.frame = CGRect(x: newBounds.origin.x, y: self.headerView.bounds.size.height, width: self.segmentView.bounds.size.width, height: self.segmentView.bounds.size.height)
                self.bgView.bounds = CGRect(x: newBounds.origin.x, y: 0, width: newBounds.size.width, height: newBounds.size.height)
            }
        }
    }
}

extension WJSwipeTableView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.weakDelegate?.swipeTableViewDidScroll!(swipeTableView: self, scrollView: self.scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.updateScrollviewContent(scrollView)
        self.weakDelegate?.swipeTableViewDidEndScrollingAnimation!(swipeTableView: self, scrollView: self.scrollView, index: self.currentIndex)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.updateScrollviewContent(scrollView)
        self.weakDelegate?.swipeTableViewDidEndDecelerating!(swipeTableView: self, scrollView: self.scrollView, index: self.currentIndex)
    }
}


//extension WJSwipeTableView: WJHeaderViewDelegate {
//    func headerViewDidPan(headerView: WJHeaderView, newBounds: CGRect) {
//        self.topViewDidiPan(newBounds: newBounds)
//    }
//
//    func headerViewBoundsWillGoBack(headerView: WJHeaderView, newBounds: CGRect) {
//        let segmentY = self.headerView.frame.size.height - newBounds.origin.y
//        self.boundsGoBack(segmentY: segmentY, newBounds: newBounds)
//    }
//}

//extension WJSwipeTableView: WJSegmentViewDelegate {
//    func segmentViewDidPan(segmentView: WJSegmentView, newBounds: CGRect) {
//        if (self.dataArray != nil && self.dataArray.count > self.currentIndex) {
//            let tableview = self.dataArray[self.currentIndex] as! UITableView
//            if (tableview.contentOffset.y == 0) {
//                self.topViewDidiPan(newBounds: newBounds)
//            }
//        } else {
//            self.topViewDidiPan(newBounds: newBounds)
//        }
//    }
//}

extension WJSwipeTableView: WJBaseMoveViewDelegate {
    func moveViewDidPan(moveView: WJBaseMoveView, newBounds: CGRect) {
        self.topViewDidiPan(newBounds: newBounds, moveViewType: moveView.moveViewType)
    }
    
    func moveViewBoundsWillGoBack(moveView: WJBaseMoveView, newBounds: CGRect) {
        let segmentY = self.headerView.frame.size.height - newBounds.origin.y
        self.boundsGoBack(segmentY: segmentY, newBounds: newBounds)
    }
    
    func moveViewDidBeganMove(moveView: WJBaseMoveView) {
        self.headerView.endDecelerating()
        self.segmentView.endDecelerating()
    }
}
