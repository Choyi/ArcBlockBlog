//
//  UIColor.swift
//  ArcBlockBlog
//
//  Created by Jiang Zhuoyi on 26/12/2024.
//

import UIKit

extension UIColor {
    /// 使用十六进制色值创建颜色
    convenience init(_ hex: Int) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255.0,
            green: CGFloat((hex >> 8) & 0xFF) / 255.0,
            blue: CGFloat(hex & 0xFF) / 255.0,
            alpha: 1
        )
    }

    /// 使用十六进制色值创建 light / dark 颜色
    convenience init(_ lightHex: Int, _ darkHex: Int) {
        self.init {
            $0.userInterfaceStyle == .dark ? UIColor(darkHex) : UIColor(lightHex)
        }
    }

    /// 转为十六进制色值字符串
    func toHexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        guard getRed(&r, green: &g, blue: &b, alpha: nil) else {
            return ""
        }
        return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }
}
