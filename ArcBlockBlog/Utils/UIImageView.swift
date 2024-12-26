//
//  UIImageView.swift
//  ArcBlockBlog
//
//  Created by Jiang Zhuoyi on 26/12/2024.
//

import UIKit
import SDWebImage

extension UIImageView {
    /// 添加加载指示器
    func addLoadingIndicator() {
        sd_imageIndicator = SDWebImageActivityIndicator.medium
    }

    /// 添加渐变
    func addFadeTransition() {
        sd_imageTransition = .fade(duration: 0.3)
    }

    /// 加载网络图片
    func setImage(path: String?, size: CGSize? = nil) {
        var context: [SDWebImageContextOption: Any] = [:]

        if let size {
            let scale = UIScreen.main.scale
            let thumbSize = CGSize(size.width * scale, size.height * scale)
            context[.imageTransformer] = SDImageResizingTransformer(size: thumbSize, scaleMode: .fill)
        }

        sd_setImage(
            with: path.flatMap { URL(string: Env.shared.makeImageURL($0)) },
            placeholderImage: nil,
            options: [
                .scaleDownLargeImages,
                .retryFailed,
            ],
            context: context
        )
    }

    func cancelImageLoad() {
        sd_cancelCurrentImageLoad()
    }
}
