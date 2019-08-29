//
//  WJDynamicItem.swift
//  内存管理实例
//
//  Created by 汪俊 on 2018/5/28.
//  Copyright © 2018年 汪俊. All rights reserved.
//

import UIKit

class WJDynamicItem: NSObject {
    
    var tempCenter: CGPoint!
    var tempBounds: CGRect!
    var tempTransform: CGAffineTransform!
    override init() {
        super.init()
        self.bounds = CGRect(x: 0, y: 0, width: 1, height: 1)
    }
}

extension WJDynamicItem: UIDynamicItem {
    var center: CGPoint {
        get {
            if (self.tempCenter == nil) {
                self.tempCenter = CGPoint(x: 0, y: 0)
            }
            return self.tempCenter
        }
        set(center) {
            self.tempCenter = center
        }
    }
    
    var bounds: CGRect {
        get {
            return self.tempBounds
        }
        set(bounds) {
            self.tempBounds = bounds
        }
    }
    
    var transform: CGAffineTransform {
        get {
            if (self.tempTransform == nil) {
                self.tempTransform = CGAffineTransform.init(a: 1, b: 0, c: -0, d: 1, tx: 0, ty: 0)
            }
            return self.tempTransform
        }
        set(transform) {
            self.tempTransform = transform
        }
    }
}

