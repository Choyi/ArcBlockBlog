//
//  BlogList.swift
//  ArcBlockBlog
//
//  Created by Jiang Zhuoyi on 28/12/2024.
//

import UIKit

enum BlogList {
    /// Blog 列表内边距
    static let inset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

    /// 列表项间距
    static let spacing = 16.0

    /// 封面图宽高比
    static let coverRatio = 1350.0 / 2400.0

    /// 列数
    static func numberOfColumns() -> Int {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return UIDevice.current.orientation.isLandscape ? 3 : 2
        } else {
            return 1
        }
    }
}
