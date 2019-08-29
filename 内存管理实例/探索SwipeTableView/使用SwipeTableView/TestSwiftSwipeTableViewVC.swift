//
//  TestSwiftSwipeTableViewVC.swift
//  内存管理实例
//
//  Created by 汪俊 on 2018/5/18.
//  Copyright © 2018年 汪俊. All rights reserved.
//

import UIKit

@objc class TestSwiftSwipeTableViewVC: UIViewController {
    
    var screenWidth:CGFloat =  UIScreen.main.bounds.size.width  //[UIScreen mainScreen].bounds.size.width
    var screenHeight:CGFloat = UIScreen.main.bounds.size.height
    var currentImage: UIImage!
    var shadowImage: UIImage!
    var swipeTableView: WJSwipeTableView!
    var segmentView: WJSegmentView!
    var headerView: WJHeaderView!
    var kIndicatorWidthProportion: CGFloat! // 指示条和单个按钮的比例
    var kIndicatorLeftProportion: CGFloat! // 距离左边的距离和单个按钮的比例
    let indicatesViewHeight = CGFloat(2)

    
    var isAnimation: Bool! = false
    var lastButton: UIButton!
    var indicatesView: UIView!
    /**
     * 懒加载
     */
    lazy var btnsArray: NSMutableArray! = NSMutableArray.init()
    lazy var titleArray: NSArray = {
        () -> NSArray in
        self.titleArray = [
            "第一条",
            "第二条"
        ]
        return self.titleArray
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.kIndicatorWidthProportion = 0.6
        self.kIndicatorLeftProportion = ((1 - self.kIndicatorWidthProportion) / 2.0)
        
        self.currentImage = self.navigationController?.navigationBar.backgroundImage(for: .default)
        self.shadowImage = self.navigationController?.navigationBar.shadowImage
        
        let swipeTableView = WJSwipeTableView.init(frame: self.view.bounds)
        self.swipeTableView = swipeTableView
        swipeTableView.weakDelegate = self
        self.view.addSubview(swipeTableView)
        swipeTableView.autoresizingMask = UIViewAutoresizing.flexibleHeight.union(.flexibleWidth)
        
        self.initHeaderView()
        self.initSegmentView()
        
        let dataArray = NSMutableArray()
        
        for _ in 0...1 {
            let vc = ShowSwiftDataVC()
            self.addChildViewController(vc)
            vc.viewDidLoad()
            dataArray.add(vc.tableView)
        }
        self.swipeTableView.dataArray = dataArray
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.swipeTableViewIsHiddenNavagatinBar(swipeTableView: self.swipeTableView, isHiddenNavagatinBar: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.swipeTableViewIsHiddenNavagatinBar(swipeTableView: self.swipeTableView, isHiddenNavagatinBar: false)
    }
    
    static func testSwiftSwipeTableViewVC() -> TestSwiftSwipeTableViewVC {
        return TestSwiftSwipeTableViewVC.init()
    }
}

extension TestSwiftSwipeTableViewVC {
    
    func initHeaderView() {
        let headerImage = UIImage.init(named: "onepiece_kiudai")
        let headerImageH = screenWidth * ((headerImage?.size.height)!/(headerImage?.size.width == 0 ? screenWidth : (headerImage?.size.width)!))
        
        let headerView = WJHeaderView.headerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: headerImageH))
        self.headerView = headerView
        headerView.backgroundColor = UIColor.lightGray
        
        let headerImageView = UIImageView.init()
        headerImageView.frame = CGRect(x: 0, y: 0, width: headerView.frame.size.width, height: headerView.frame.size.height)
        headerView.addSubview(headerImageView)
        headerImageView.image = headerImage
        
        self.swipeTableView.headerView = headerView
    }
    
    func initSegmentView() {
        let segmentView = WJSegmentView.segmentView(frame: CGRect(x: 0, y: self.headerView.frame.size.height, width: screenWidth, height: 44))
        self.segmentView = segmentView
        segmentView.backgroundColor = UIColor.orange
        
        self.btnsArray.removeAllObjects()
        let count = self.titleArray.count - 1
        let btnWidth = segmentView.bounds.size.width / CGFloat(self.titleArray.count)
        for i in 0...count {
            let btn = UIButton(type: UIButtonType.custom)
            segmentView .addSubview(btn)
            btn.frame = CGRect(x: CGFloat(i) * btnWidth, y: 0, width: btnWidth, height: segmentView.bounds.size.height - self.indicatesViewHeight)
            btn.setTitle((self.titleArray[i] as! String), for: UIControlState.normal)
            btn.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
            btn.setTitleColor(UIColor(red: 67.0/255.0, green: 133.0/255.0, blue: 245.0/255.0, alpha: 1.0), for: UIControlState.highlighted)
            btn.setTitleColor(UIColor(red: 67.0/255.0, green: 133.0/255.0, blue: 245.0/255.0, alpha: 1.0), for: UIControlState.selected)
            btn.tag = i
            btn.addTarget(self, action: #selector(self.didClickBtn(btn:)), for: UIControlEvents.touchUpInside)
            self.btnsArray.add(btn)
            if (i == count) {
                self.lastButton = btn
            }
        }
        
        let indicatesView = UIView()
        indicatesView.frame = CGRect(x: self.kIndicatorLeftProportion * btnWidth, y: segmentView.bounds.size.height - self.indicatesViewHeight, width: btnWidth * self.kIndicatorWidthProportion, height: self.indicatesViewHeight)
        indicatesView.backgroundColor = UIColor(red: 67.0/255.0, green: 133.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        segmentView.addSubview(indicatesView)
        self.indicatesView = indicatesView
        if (self.btnsArray.count > 0) {
            self.didClickBtn(btn: self.btnsArray[0] as! UIButton)
        }
        
        self.swipeTableView.segmentView = segmentView
    }
    
    func updateScrollviewContent(_ scrollView: UIScrollView, index: Int) {
        
        //取到对应页数的btn, 然后设置选中状态
        let btn = self.btnsArray[Int(index)] as! UIButton
        self.didClickBtn(btn: btn)
    }
    
    @objc func didClickBtn(btn :UIButton) {
//        print(self.swipeTableView.bgView.bounds)
//        print(self.headerView.frame)
//        print(self.swipeTableView.scrollView.frame)
        if (btn.isSelected) {return}
        self.isAnimation = true
        self.lastButton.isSelected = false
        btn.isSelected = true
        self.lastButton = btn
        let btnWidth = self.segmentView.bounds.size.width / CGFloat(self.titleArray.count)
        UIView.animate(withDuration: 0.3, animations: {
            self.indicatesView.frame = CGRect(x: CGFloat(btn.tag) * btnWidth + self.kIndicatorLeftProportion * btnWidth, y: self.segmentView.bounds.size.height - self.indicatesViewHeight, width: btnWidth * self.kIndicatorWidthProportion, height: self.indicatesViewHeight)
        }) { (_) in
            self.isAnimation = false
        }
        
        self.swipeTableView.setSegmentIndex(index: btn.tag)
//        // 让底部的内容scrollView滚动到对应位置
//        var offset = self.scrollView.contentOffset
//        offset.x = CGFloat(btn.tag) * self.scrollView.bounds.size.width
//        self.scrollView.setContentOffset(offset, animated: true)
    }
    
}

extension TestSwiftSwipeTableViewVC: WJSwipeTableViewDelegate {
    func swipeTableViewDidScroll(swipeTableView: WJSwipeTableView, scrollView: UIScrollView) {
        if (!self.isAnimation) {
            // 左边的间距 0.2的按钮高度 右边的0.6 + 0.2
            let indicatesViewX = scrollView.contentOffset.x * CGFloat(self.titleArray.count - 1) / CGFloat(self.titleArray.count) + self.kIndicatorLeftProportion * self.screenWidth / CGFloat(self.titleArray.count);
            self.indicatesView.frame = CGRect(x: indicatesViewX, y: self.indicatesView.frame.origin.y, width: self.indicatesView.bounds.size.width, height: self.indicatesView.bounds.size.height)
        }
    }
    
    func swipeTableViewDidEndScrollingAnimation(swipeTableView: WJSwipeTableView, scrollView: UIScrollView, index: Int) {
        self.updateScrollviewContent(scrollView, index: index)
    }
    
    func swipeTableViewDidEndDecelerating(swipeTableView: WJSwipeTableView, scrollView: UIScrollView, index: Int) {
        self.updateScrollviewContent(scrollView, index: index)
    }
    
    func swipeTableViewIsHiddenNavagatinBar(swipeTableView: WJSwipeTableView, isHiddenNavagatinBar: Bool) {
        if (isHiddenNavagatinBar) {
            self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage.init()
        } else {
            self.navigationController?.navigationBar.setBackgroundImage(self.currentImage, for: .default)
            self.navigationController?.navigationBar.shadowImage = self.shadowImage
        }
    }
}
