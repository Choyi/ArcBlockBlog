//
//  UIView.swift
//  ArcBlockBlog
//
//  Created by Jiang Zhuoyi on 26/12/2024.
//

import UIKit
import SnapKit

extension UIView {
    /// 通过 += 批量添加视图
    /// - Parameters:
    ///   - parent: 父视图
    ///   - children: 子视图集合
    @discardableResult
    static func += (parent: UIView, children: [UIView]) -> UIView {
        children.forEach { parent.addSubview($0) }
        return parent
    }

    /// 用于 frame 布局，在闭包参数中提供 sizeThatFits 返回的大小
    func layout(_ layout: (CGSize) -> CGRect) {
        frame = layout(sizeThatFits(.zero))
    }

    /// 用于 frame 布局，指定外部宽度，在闭包参数中提供 sizeThatFits 返回的大小
    func layout(maxWidth: CGFloat, _ layout: (CGSize) -> CGRect) {
        frame = layout(sizeThatFits(CGSize(maxWidth, 0)))
    }
}

extension UIView {
    /// 设置圆角
    func setCorner(radius: CGFloat, corners: UIRectCorner, color: UIColor) {
        let cornerViews = _cornerViews

        ([.topLeft, .topRight, .bottomRight, .bottomLeft] as [UIRectCorner]).enumerated().forEach {
            let cornerView = cornerViews[$0.offset]
            if corners.contains($0.element) {
                cornerView.image = UIImage.makeCornerMask(radius: radius, color: color, corners: $0.element)
                cornerView.isHidden = false
            } else {
                cornerView.image = nil
                cornerView.isHidden = true
            }
        }

        self += cornerViews

        cornerViews[0].snp.makeConstraints {
            $0.left.top.equalToSuperview()
        }

        cornerViews[1].snp.makeConstraints {
            $0.top.right.equalToSuperview()
        }

        cornerViews[2].snp.makeConstraints {
            $0.bottom.right.equalToSuperview()
        }

        cornerViews[3].snp.makeConstraints {
            $0.bottom.left.equalToSuperview()
        }
    }

    private var _cornerViews: [UIImageView] {
        lazyVarAssociatedObject {
            Array(0..<4 as Range<Int>).map { _ in
                UIImageView()
            }
        }
    }
}
