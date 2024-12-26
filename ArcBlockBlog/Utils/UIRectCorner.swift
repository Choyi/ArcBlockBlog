//
//  UIRectCorner.swift
//  ArcBlockBlog
//
//  Created by Jiang Zhuoyi on 27/12/2024.
//

import UIKit

extension UIRectCorner {
    func toString() -> String {
        if contains(.allCorners) {
            return "allCorners"
        }

        var corners: [String] = []
        if contains(.topLeft) {
            corners.append("topLeft")
        }
        if contains(.topRight) {
            corners.append("topRight")
        }
        if contains(.bottomLeft) {
            corners.append("bottomLeft")
        }
        if contains(.bottomRight) {
            corners.append("bottomRight")
        }
        if corners.isEmpty {
            return "allCorners"
        }
        return corners.joined(separator: ",")
    }
}
