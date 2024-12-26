//
//  BlogListCell.swift
//  ArcBlockBlog
//
//  Created by Jiang Zhuoyi on 26/12/2024.
//

import UIKit

extension BlogListCell {
    private static let __cell = BlogListCell()
    static func height(model: BlogListModel?, width: CGFloat) -> CGFloat {
        __cell.model = model
        return __cell._layoutSubviews(width: width) + 8
    }
}

final class BlogListCell: UICollectionViewCell {
    required init?(coder: NSCoder) { fatalError() }

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(bgView)

        bgView += [
            coverView,
            titleLabel,
            labelsView,
            dateLabel,
        ]

        bgView += shimmerViews

        updateBgViewCorners()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        _ = _layoutSubviews(width: bounds.width)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else {
            return
        }
        updateBgViewCorners()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animateScale(to: 0.95)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animateScale(to: 1.0)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animateScale(to: 1.0)
    }

    private func _layoutSubviews(width: CGFloat) -> CGFloat {
        bgView.frame = contentView.bounds

        coverView.frame = CGRect(0, 0, width, width * BlogList.coverRatio).integral

        titleLabel.layout(maxWidth: width - 16) {
            CGRect(8, coverView.frame.maxY + 8, width - 16, $0.height).integral
        }

        labelsView.layout {
            CGRect(8, titleLabel.frame.maxY + 6, width - 16, $0.height).integral
        }

        dateLabel.layout {
            CGRect(8, labelsView.frame.maxY + 8, $0.width, $0.height).integral
        }

        shimmerViews[0].frame = CGRect(0, 0, width, width * BlogList.coverRatio)
        shimmerViews[1].frame = CGRect(0, shimmerViews[0].frame.maxY + 8, width * 0.9, 18)
        shimmerViews[2].frame = CGRect(0, shimmerViews[1].frame.maxY + 8, width * 0.6, 18)
        shimmerViews[3].frame = CGRect(0, shimmerViews[2].frame.maxY + 8, width * 0.3, 18)

        return model == nil ? shimmerViews[3].frame.maxY : dateLabel.frame.maxY
    }

    /// 博文模型，nil 展示示骨架屏
    var model: BlogListModel? {
        didSet {
            guard let model else {
                isShimmering = true
                return
            }

            isShimmering = false

            coverView.setImage(path: model.cover, size: CGSize(400, 400 * BlogList.coverRatio))

            titleLabel.text = model.title

            labelsView.model = model

            dateLabel.text = model.publishTimeText
        }
    }

    func didEndDisplaying() {
        coverView.cancelImageLoad()
    }

    /// 缩放动画
    private func animateScale(to scale: CGFloat) {
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: [.allowUserInteraction, .curveEaseOut],
            animations: {
                self.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        )
    }

    private func updateBgViewCorners() {
        bgView.setCorner(radius: 8, corners: .allCorners, color: UIColor(0xF7F7F7, 0x080808))
    }

    private var isShimmering: Bool = false {
        didSet {
            shimmerViews.forEach {
                $0.isHidden = !isShimmering
                $0.isShimmering = isShimmering
            }
        }
    }

    private let bgView = UIView().then {
        $0.backgroundColor = UIColor(0xFFFFFF, 0x333333)
    }

    private let coverView = UIImageView().then {
        $0.backgroundColor = UIColor(0xE6E6E6, 0x666666)
        $0.addLoadingIndicator()
        $0.addFadeTransition()
    }

    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = UIColor(0x333333, 0xCCCCCC)
        $0.numberOfLines = 1
    }

    private let labelsView = BlogLabelsView()

    private let dateLabel = UILabel().then {
        $0.textColor = UIColor(0x999999, 0x999999)
        $0.font = .systemFont(ofSize: 12)
    }

    private let shimmerViews = Array(0..<4 as Range<Int>).map { _ in
        ShimmerView().then {
            $0.isHidden = true
        }
    }
}
