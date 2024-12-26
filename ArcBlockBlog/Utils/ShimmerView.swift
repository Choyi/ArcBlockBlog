//
//  ShimmerView.swift
//  ArcBlockNews
//
//  Created by Jiang Zhuoyi on 27/12/2024.
//

import UIKit

/// 闪烁效果的视图
final class ShimmerView: UIView {
    required init?(coder: NSCoder) { fatalError() }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(0xE6E6E6, 0x333333)
        layer.cornerRadius = 4
        clipsToBounds = true
        layer.addSublayer(gradientLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    /// 是否显示闪烁效果
    var isShimmering: Bool = false {
        didSet {
            if isShimmering {
                startShimmerAnimation()
            } else {
                stopShimmerAnimation()
            }
        }
    }

    private func startShimmerAnimation() {
        let lightColor = UIColor.white.withAlphaComponent(0.1).cgColor
        let darkColor = UIColor.white.withAlphaComponent(0.3).cgColor

        gradientLayer.colors = [lightColor, darkColor, lightColor]
        gradientLayer.locations = [0.0, 0.5, 1.0]

        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.duration = 1.5
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: "shimmerAnimation")
    }

    private func stopShimmerAnimation() {
        gradientLayer.removeAllAnimations()
    }

    private let gradientLayer = CAGradientLayer().then {
        $0.startPoint = CGPoint(x: 0.0, y: 0.25)
        $0.endPoint = CGPoint(x: 1.0, y: 0.75)
    }
}
