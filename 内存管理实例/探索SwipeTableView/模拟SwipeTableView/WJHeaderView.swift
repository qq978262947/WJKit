//
//  WJHeaderView2.swift
//  内存管理实例
//
//  Created by 汪俊 on 2018/5/18.
//  Copyright © 2018年 汪俊. All rights reserved.
//

import UIKit

//protocol WJHeaderViewDelegate {
//    func headerViewDidPan(headerView: WJHeaderView, newBounds: CGRect)
//    func headerViewBoundsWillGoBack(headerView: WJHeaderView, newBounds: CGRect)
//}
//
//class WJHeaderView: UIView {
//    var isWillGoBack: Bool!
//    var navBarHeight: CGFloat!
//    var _animator: UIDynamicAnimator!
//    var animator: UIDynamicAnimator! {
//        set {
//            if (_animator != newValue) {
//                if (_animator != nil) {
//                    _animator.delegate = nil
//                    _animator.removeAllBehaviors()
//                    _animator = newValue
//                }
//            }
//        }
//        get {
//            if (_animator == nil) {
//                if (self.superview != nil) {
//                    _animator =  UIDynamicAnimator.init(referenceView: self.superview!)
//                } else {
//                    _animator =  UIDynamicAnimator.init(referenceView: self)
//                }
//            }
//            return _animator
//        }
//    }
//    var dynamicItem: WJDynamicItem!
//    var decelerationBehavior: UIDynamicItemBehavior!
//    var springBehavior: UIAttachmentBehavior!
//    var weakDelegate:WJHeaderViewDelegate?
//    var oldBounds: CGRect?
//
//
//    required override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.initView()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        self.initView()
//    }
//
//    static func headerView(frame: CGRect, dynamicAnimator: UIDynamicAnimator) -> WJHeaderView {
//        let headerView = WJHeaderView.init(frame: frame)
//        headerView.animator = dynamicAnimator
//        dynamicAnimator.delegate = headerView
//        return headerView
//    }
//}
//
//
//private extension WJHeaderView {
//
//    func initView() {
//        let isIponeX: Bool = __CGSizeEqualToSize(CGSize(width: 1125, height: 2436), UIScreen.main.currentMode!.size)
//        self.navBarHeight = isIponeX ? 88: 64
//        // 手势
//        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(self.didPanGesture(panGesture:)))
//        self.addGestureRecognizer(gesture)
//        self.dynamicItem = WJDynamicItem()
//    }
//
//    @objc func didPanGesture(panGesture: UIPanGestureRecognizer) {
//        switch panGesture.state {
//        case .began:
//            self.endDecelerating()
//            self.oldBounds = (self.superview?.bounds)!
//            break
//        case .changed:
//            var bounds = self.oldBounds!
//            let translation = panGesture.translation(in: self.superview)
//            bounds.origin = CGPoint(x: bounds.origin.x, y: bounds.origin.y - translation.y)
//            self.setNewBounds(bounds: bounds)
//            break
//        case .ended:
//            var velocity = panGesture.velocity(in: self.superview)
//            velocity.y *= -1
//            velocity.x = 0
//            self.dynamicItem.center = (self.superview?.bounds.origin)!
//            self.decelerationBehavior = UIDynamicItemBehavior.init(items: [self.dynamicItem]) // 制作的减速行为
//            self.decelerationBehavior.addLinearVelocity(velocity, for: self.dynamicItem)
//            self.decelerationBehavior.resistance = 2
//            self.decelerationBehavior.action = { [weak self] ()  in
//                guard let `self` = self else {
//                    return
//                }
//                var center = self.dynamicItem.center
//                center.x = (self.superview?.bounds.origin.x)!
//                var bounds = (self.superview?.bounds)!
//                bounds.origin = center
//                self.setEndNewBounds(bounds: bounds)
//            }
//            if (self.animator != nil) {
//                self.animator.addBehavior(self.decelerationBehavior)
//            }
//
//            break
//        default:
//            break
//        }
//    }
//
//    func endDecelerating() {
//        if (self.animator != nil) {
//            self.animator.removeAllBehaviors()
//        }
//        self.decelerationBehavior = nil
//        self.springBehavior = nil
//    }
//
//    func setNewBounds(bounds: CGRect) {
//        self.weakDelegate?.headerViewDidPan(headerView: self, newBounds: bounds)
//    }
//
//    func setEndNewBounds(bounds: CGRect) {
//        let segmentY = self.frame.size.height - bounds.origin.y
//        if (segmentY < self.navBarHeight) {
//            if (self.springBehavior == nil && self.decelerationBehavior != nil) {
//                self.springBehavior = UIAttachmentBehavior.init(item: self.dynamicItem, attachedToAnchor: CGPoint(x: bounds.origin.x, y: self.frame.size.height - self.navBarHeight))
//                self.springBehavior.length = 0
//                self.springBehavior.damping = 1
//                self.springBehavior.frequency = 2
//                if (self.animator != nil) {
//                    self.animator.addBehavior(self.springBehavior)
//                }
//            }
//        }
//        if (bounds.origin.y < 0) {
//            self.weakDelegate?.headerViewBoundsWillGoBack(headerView: self, newBounds: bounds)
//        } else {
//            self.setNewBounds(bounds: bounds)
//        }
//    }
//}

class WJHeaderView: WJBaseMoveView {
    required init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.moveViewType = .header
    }
    
    override init(frame: CGRect, moveType: MoveViewType) {
        super.init(frame: frame, moveType: moveType)
    }
    
    static func headerView(frame: CGRect) -> WJHeaderView {
        let headerView = WJHeaderView.init(frame: frame, moveType: MoveViewType.header)
        return headerView
    }
}

extension WJHeaderView: UIDynamicAnimatorDelegate {
    
}
