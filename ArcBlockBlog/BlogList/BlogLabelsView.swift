//
//  BlogLabelsView.swift
//  ArcBlockBlog
//
//  Created by Jiang Zhuoyi on 26/12/2024.
//

import UIKit

private let HorizontalPadding = 5.0 * 2
private let Height = 17.0

final class BlogLabelsView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        _ = labelViews.reduce(0.0) { left, labelView in
            labelView.layout {
                CGRect(left, 0, $0.width + HorizontalPadding, Height).integral
            }
            labelView.isHidden = labelView.frame.maxX > bounds.width
            return labelView.frame.maxX + 8.0
        }
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        CGSize(size.width, Height)
    }

    var model: BlogListModel? {
        didSet {
            labels = (model?.labels ?? []).filter {
                !$0.hasPrefix("assign:")
            }
            setNeedsLayout()
        }
    }

    private func makeLabel() -> UILabel {
        UILabel().then {
            $0.font = .systemFont(ofSize: 12)
            $0.textAlignment = .center
            $0.backgroundColor = UIColor(0xF5F5F5)
            $0.layer.borderColor = UIColor(0xE0E0E0).cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 4
            $0.layer.masksToBounds = true
            $0.textColor = UIColor(0x000000).withAlphaComponent(0.6)
            addSubview($0)
        }
    }

    private var labels: [String] = [] {
        didSet {
            labelViews.forEach {
                $0.isHidden = true
            }
            labelViews = labels.enumerated().map { (index, label) in
                (labelViews[safe: index] ?? makeLabel()).then {
                    $0.isHidden = false
                    $0.text = label
                }
            }
            setNeedsLayout()
        }
    }

    private var labelViews: [UILabel] = []
}
