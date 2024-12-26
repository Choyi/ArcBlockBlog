//
//  EmptyView.swift
//  ArcBlockBlog
//
//  Created by Jiang Zhuoyi on 28/12/2024.
//

import UIKit
import SnapKit

/// 空内容视图
final class EmptyView: UIView {
    required init?(coder: NSCoder) { fatalError() }

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
        self += [
            imageView,
            titleLabel,
            subtitleLabel,
        ]
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect((bounds.width - 60) / 2, (bounds.height - 60) / 4, 60, 60)
        titleLabel.layout {
            CGRect((bounds.width - $0.width) / 2, imageView.frame.maxY + 16, $0.width, $0.height)
        }
        subtitleLabel.layout {
            CGRect((bounds.width - $0.width) / 2, titleLabel.frame.maxY + 8, $0.width, $0.height)
        }
    }

    private let imageView = UIImageView().then {
        $0.image = UIImage(systemName: "exclamationmark.triangle")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = .systemGray3
        $0.contentMode = .scaleAspectFit
    }

    private let titleLabel = UILabel().then {
        $0.text = "加载失败"
        $0.textColor = .systemGray
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textAlignment = .center
    }

    private let subtitleLabel = UILabel().then {
        $0.text = "下拉刷新重试"
        $0.textColor = .systemGray2
        $0.font = .systemFont(ofSize: 14)
        $0.textAlignment = .center
    }
}
