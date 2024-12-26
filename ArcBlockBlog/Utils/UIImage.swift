//
//  UIImage.swift
//  ArcBlockBlog
//
//  Created by Jiang Zhuoyi on 27/12/2024.
//

import UIKit
import Cache

extension UIImage {
    private static let imageCache = MemoryStorage<String, UIImage>(config: MemoryConfig())

    /// 生成圆角遮罩图片
    /// - Parameters:
    ///   - radius: 圆角半径
    ///   - color: 前景色
    ///   - corners: 圆角位置
    /// - Returns: 生成的圆角图片
    static func makeCornerMask(radius: CGFloat, color: UIColor, corners: UIRectCorner) -> UIImage? {
        let key = "Corner_\(radius)_\(color.toHexString())_\(corners.toString())"
        if let image = try? imageCache.object(forKey: key) {
            return image
        }
        let size = CGSize(UIScreen.main.scale * radius, UIScreen.main.scale * radius)
        let image = UIGraphicsImageRenderer(size: size).image { context in
            // 先用前景色填充整个区域
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))

            // 创建圆角路径并清除该区域
            let path = UIBezierPath(
                roundedRect: CGRect(origin: .zero, size: size),
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: radius, height: radius)
            )

            context.cgContext.setBlendMode(.clear)
            UIColor.black.setFill()
            path.fill()
        }
        imageCache.setObject(image, forKey: key)
        return image
    }
}
