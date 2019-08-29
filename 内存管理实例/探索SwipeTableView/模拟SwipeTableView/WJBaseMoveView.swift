//
//  WJBaseMoveView.swift
//  内存管理实例
//
//  Created by 汪俊 on 2018/5/29.
//  Copyright © 2018年 汪俊. All rights reserved.
//

import UIKit

enum MoveViewType: Int {
    case header, segment
}

protocol WJBaseMoveViewDelegate {
    func moveViewDidBeganMove(moveView: WJBaseMoveView)
    func moveViewDidPan(moveView: WJBaseMoveView, newBounds: CGRect)
    func moveViewBoundsWillGoBack(moveView: WJBaseMoveView, newBounds: CGRect)
}

class WJBaseMoveView: UIView {
    
    var moveViewType: MoveViewType! = .header
    var isWillGoBack: Bool!
    var navBarHeight: CGFloat!
    var _animator: UIDynamicAnimator!
    var animator: UIDynamicAnimator! {
        set {
            if (_animator != newValue) {
                if (_animator != nil) {
                    _animator.delegate = nil
                    _animator.removeAllBehaviors()
                    _animator = newValue
                }
            }
        }
        get {
            if (_animator == nil) {
                if ((self.moveViewType == .header ? self.superview : (self.superview as! WJSwipeTableView).bgView) != nil) {
                    _animator =  UIDynamicAnimator.init(referenceView: (self.moveViewType == .header ? self.superview : (self.superview as! WJSwipeTableView).bgView)!)
                } else {
                    _animator =  UIDynamicAnimator.init(referenceView: self)
                }
            }
            return _animator
        }
    }
    var dynamicItem: WJDynamicItem!
    var decelerationBehavior: UIDynamicItemBehavior!
    var springBehavior: UIAttachmentBehavior!
    var weakDelegate:WJBaseMoveViewDelegate?
    var oldBounds: CGRect?
    
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    init(frame: CGRect, moveType: MoveViewType) {
        super.init(frame: frame)
        self.moveViewType = moveType
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initView()
    }
    
    func endDecelerating() {
        if (self.animator != nil) {
            self.animator.removeAllBehaviors()
            self.animator = nil
        }
        self.decelerationBehavior = nil
        self.springBehavior = nil
    }
}


private extension WJBaseMoveView {
    
    func initView() {
        let isIponeX: Bool = __CGSizeEqualToSize(CGSize(width: 1125, height: 2436), UIScreen.main.currentMode!.size)
        self.navBarHeight = isIponeX ? 88: 64
        // 手势
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(self.didPanGesture(panGesture:)))
        self.addGestureRecognizer(gesture)
        self.dynamicItem = WJDynamicItem()
    }
    
    @objc func didPanGesture(panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .began:
            self.weakDelegate?.moveViewDidBeganMove(moveView: self)
//            self.endDecelerating()
//            if (self.moveViewType == .header) {
//
//            }
            
            self.oldBounds = ((self.moveViewType == .header ? self.superview : (self.superview as! WJSwipeTableView).bgView)?.bounds)!
            break
        case .changed:
            var bounds = self.oldBounds!
            let translation = panGesture.translation(in: (self.moveViewType == .header ? self.superview : (self.superview as! WJSwipeTableView).bgView))
            bounds.origin = CGPoint(x: bounds.origin.x, y: bounds.origin.y - translation.y)
            self.setNewBounds(bounds: bounds)
            break
        case .ended:
            var velocity = panGesture.velocity(in: (self.moveViewType == .header ? self.superview : (self.superview as! WJSwipeTableView).bgView))
            velocity.y *= -1
            velocity.x = 0
            self.dynamicItem.center = ((self.moveViewType == .header ? self.superview : (self.superview as! WJSwipeTableView).bgView)?.bounds.origin)!
            self.decelerationBehavior = UIDynamicItemBehavior.init(items: [self.dynamicItem]) // 制作的减速行为
            self.decelerationBehavior.addLinearVelocity(velocity, for: self.dynamicItem)
            self.decelerationBehavior.resistance = 2
            self.decelerationBehavior.action = { [weak self] ()  in
                guard let `self` = self else {
                    return
                }
                var center = self.dynamicItem.center
                center.x = ((self.moveViewType == .header ? self.superview : (self.superview as! WJSwipeTableView).bgView)?.bounds.origin.x)!
                var bounds = ((self.moveViewType == .header ? self.superview : (self.superview as! WJSwipeTableView).bgView)?.bounds)!
                bounds.origin = center
                self.setEndNewBounds(bounds: bounds)
            }
            if (self.animator != nil) {
                self.animator.addBehavior(self.decelerationBehavior)
            }
            
            break
        default:
            break
        }
    }
    
    
    func setNewBounds(bounds: CGRect) {
        self.weakDelegate?.moveViewDidPan(moveView: self, newBounds: bounds)
    }
    
    func setEndNewBounds(bounds: CGRect) {
        let moveViewFrame = self.moveViewType == .header ? self.frame : (self.superview as! WJSwipeTableView).headerView.frame
        
        let segmentY = moveViewFrame.size.height - bounds.origin.y
        if (segmentY < self.navBarHeight) {
            if (self.springBehavior == nil && self.decelerationBehavior != nil) {
                self.springBehavior = UIAttachmentBehavior.init(item: self.dynamicItem, attachedToAnchor: CGPoint(x: bounds.origin.x, y: moveViewFrame.size.height - self.navBarHeight))
                self.springBehavior.length = 0
                self.springBehavior.damping = 1
                self.springBehavior.frequency = 2
                if (self.animator != nil) {
                    self.animator.addBehavior(self.springBehavior)
                }
            }
        }
        if (bounds.origin.y < 0) {
            self.weakDelegate?.moveViewBoundsWillGoBack(moveView: self, newBounds: bounds)
        } else {
            self.setNewBounds(bounds: bounds)
        }
    }
}
