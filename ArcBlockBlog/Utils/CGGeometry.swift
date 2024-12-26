//
//  CGGeometry.swift
//  ArcBlockBlog
//
//  Created by Jiang Zhuoyi on 26/12/2024.
//

import Foundation
import CoreGraphics
import UIKit

extension CGSize {
    /// 未命名参数的初始化
    init(_ width: CGFloat, _ height: CGFloat) {
        self.init(width: width, height: height)
    }
}

extension CGRect {
    /// 未命名参数的初始化
    init(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) {
        self.init()
        self.origin = CGPoint(x: x, y: y)
        self.size = CGSize(width: width, height: height)
    }
}

extension CGPoint {
    /// 未命名参数的初始化
    init(_ x: CGFloat, _ y: CGFloat) {
        self.init()
        self.x = x
        self.y = y
    }
}
