//
//  ImageManager.swift
//  ArcBlockBlog
//
//  Created by Jiang Zhuoyi on 28/12/2024.
//

import UIKit
import SDWebImage

final class ImageManager {
    static let shared = ImageManager()

    /// 清除缓存
    func clear() {
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
    }
}
