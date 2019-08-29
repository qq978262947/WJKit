//
//  InteractionScrollView.swift
//  内存管理实例
//
//  Created by 汪俊 on 2018/5/14.
//  Copyright © 2018年 汪俊. All rights reserved.
//

import UIKit


@objc class InteractionVC: UIViewController {
    
    var kIndicatorWidthProportion: CGFloat! // 指示条和单个按钮的比例
    var kIndicatorLeftProportion: CGFloat! // 距离左边的距离和单个按钮的比例
    var indicatesView: UIView!
    var headerView: UIView!
    var scrollView: UIScrollView!
    let indicatesViewHeight = CGFloat(2)
    var isAnimation: Bool! = false
    var lastButton: UIButton!
    var btnsArray: NSMutableArray!
    /**
     * 懒加载
     */
    lazy var dataArray: NSArray = {
        () -> NSArray in
        self.dataArray = [
            "OC与Swift混编",
            "纯Swift"
        ]
        return self.dataArray
    }()
    
    var screenWidth:CGFloat =  UIScreen.main.bounds.size.width  //[UIScreen mainScreen].bounds.size.width
    var screenHeight:CGFloat = UIScreen.main.bounds.size.height
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupData()
        
        self.initNavigationBar()
        
        self.initView()
    }
}

extension InteractionVC {
    
    func setupData() {
        self.kIndicatorWidthProportion = 0.6
        self.kIndicatorLeftProportion = ((1 - self.kIndicatorWidthProportion) / 2.0)
        self.btnsArray = NSMutableArray()
    }
    
    func initNavigationBar() {
        // 没有需要搞的
    }
    
    func initView() {
        // 内容
        self.initContentView()
        // scrollView
        self.initScrollView()
        // 头部
        self.initHeaderView()
    }

    func initContentView() {
        // 64测试的，不考虑iponex
        let contentView = UIView.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        contentView.backgroundColor = UIColor.white
        self.view.addSubview(contentView)
    }
    
    func initScrollView() {
//        let scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 64 + 40, width: screenWidth, height: screenHeight - 40 - 64))
//        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        let scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        self.scrollView = scrollView
        scrollView.contentInset = UIEdgeInsetsMake(64 + 40, 0, 40 + 64, 0)
        scrollView.contentSize = CGSize(width: screenWidth * 2.0, height: 0)
        scrollView.backgroundColor = UIColor.white
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        
        let count = self.dataArray.count - 1
        for i in 0...count {
            let vc = ShowSwiftDataVC()
            self.addChildViewController(vc)
            scrollView.addSubview(vc.view)
            vc.view.frame = CGRect(x: CGFloat(i) * screenWidth, y: 0, width: scrollView.bounds.size.width, height: scrollView.bounds.size.height)
        }
    }
    
    func initHeaderView() {
        let headerView = UIView.init(frame: CGRect(x: 0, y: 64, width: screenWidth, height: 40))
        headerView.backgroundColor = UIColor.white
        self.view.addSubview(headerView)
        self.headerView = headerView
        
        self.btnsArray.removeAllObjects()
        let count = self.dataArray.count - 1
        let btnWidth = self.view.bounds.size.width / CGFloat(self.dataArray.count)
        for i in 0...count {
            let btn = UIButton(type: UIButtonType.custom)
            headerView .addSubview(btn)
            btn.frame = CGRect(x: CGFloat(i) * btnWidth, y: 0, width: btnWidth, height: headerView.bounds.size.height - self.indicatesViewHeight)
            btn.setTitle((self.dataArray[i] as! String), for: UIControlState.normal)
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
        indicatesView.frame = CGRect(x: self.kIndicatorLeftProportion * btnWidth, y: headerView.bounds.size.height - self.indicatesViewHeight, width: btnWidth * self.kIndicatorWidthProportion, height: self.indicatesViewHeight)
        indicatesView.backgroundColor = UIColor(red: 67.0/255.0, green: 133.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        headerView.addSubview(indicatesView)
        self.indicatesView = indicatesView
        if (self.btnsArray.count > 0) {
            self.didClickBtn(btn: self.btnsArray[0] as! UIButton)
        }
    }
    
    func didClickBtn(btn :UIButton) {
        if (btn.isSelected) {return}
        self.isAnimation = true
        self.lastButton.isSelected = false
        btn.isSelected = true
        self.lastButton = btn
        let btnWidth = self.view.bounds.size.width / CGFloat(self.dataArray.count)
        UIView.animate(withDuration: 0.3, animations: {
            self.indicatesView.frame = CGRect(x: CGFloat(btn.tag) * btnWidth + self.kIndicatorLeftProportion * btnWidth, y: self.headerView.bounds.size.height - self.indicatesViewHeight, width: btnWidth * self.kIndicatorWidthProportion, height: self.indicatesViewHeight)
        }) { (_) in
            self.isAnimation = false
        }
        // 让底部的内容scrollView滚动到对应位置
        var offset = self.scrollView.contentOffset
        offset.x = CGFloat(btn.tag) * self.scrollView.bounds.size.width
        self.scrollView.setContentOffset(offset, animated: true)
    }
    
    func updateScrollviewContent(_ scrollView: UIScrollView) {
        // 一些临时变量
        let width = self.screenWidth
        let offsetX = scrollView.contentOffset.x
        
        // 当前位置需要显示的控制器的索引
        let index = offsetX / width
        
        //取到对应页数的btn, 然后设置选中状态
        let btn = self.btnsArray[Int(index)] as! UIButton
        self.didClickBtn(btn: btn)
    }
}

extension InteractionVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!self.isAnimation) {
            // 左边的间距 0.2的按钮高度 右边的0.6 + 0.2
            let indicatesViewX = scrollView.contentOffset.x * CGFloat(self.dataArray.count - 1) / CGFloat(self.dataArray.count) + self.kIndicatorLeftProportion * self.screenWidth / CGFloat(self.dataArray.count);
            self.indicatesView.frame = CGRect(x: indicatesViewX, y: self.indicatesView.frame.origin.y, width: self.indicatesView.bounds.size.width, height: self.indicatesView.bounds.size.height)
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.updateScrollviewContent(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.updateScrollviewContent(scrollView)
    }
}
