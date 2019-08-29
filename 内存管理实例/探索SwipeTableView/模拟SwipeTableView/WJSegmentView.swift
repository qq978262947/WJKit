//
//  WJSegmentView.swift
//  内存管理实例
//
//  Created by 汪俊 on 2018/5/18.
//  Copyright © 2018年 汪俊. All rights reserved.
//

import UIKit

//protocol WJSegmentViewDelegate {
//    func segmentViewDidPan(segmentView: WJSegmentView, newBounds: CGRect)
//}
//
//
//class WJSegmentView: UIView {
//
//    var weakDelegate:WJSegmentViewDelegate?
//    var oldBounds: CGRect?
//    required override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.initView()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        self.initView()
//    }
//}
//
//private extension WJSegmentView {
//
//    func initView() {
//        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(self.didPanGesture(panGesture:)))
//        self.addGestureRecognizer(gesture)
//    }
//
//    @objc func didPanGesture(panGesture: UIPanGestureRecognizer) {
//        switch panGesture.state {
//        case .began:
//            let swipeTableView = self.superview as! WJSwipeTableView
//            self.oldBounds = swipeTableView.bgView.bounds
//            break
//        case .changed:
//            var bounds = self.oldBounds!
//            let translation = panGesture.translation(in: self.superview)
//            bounds.origin = CGPoint(x: bounds.origin.x, y: bounds.origin.y - translation.y)
//            self.setNewBounds(bounds: bounds)
//            break
//        case .ended:
//            break
//        default:
//            break
//        }
//    }
//
//    func setNewBounds(bounds: CGRect) {
//        self.weakDelegate?.segmentViewDidPan(segmentView: self, newBounds: bounds)
//    }
//}

class WJSegmentView: WJBaseMoveView {
    
    required init(frame: CGRect) {
        super.init(frame: frame)
        self.moveViewType = .segment
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.moveViewType = .segment
    }
    
    override init(frame: CGRect, moveType: MoveViewType) {
        super.init(frame: frame, moveType: moveType)
    }
    
    static func segmentView(frame: CGRect) -> WJSegmentView {
        let segmentView = WJSegmentView.init(frame: frame, moveType: MoveViewType.segment)
        return segmentView
    }
}
