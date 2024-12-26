//
//  Toast.swift
//  ArcBlockNews
//
//  Created by Jiang Zhuoyi on 27/12/2024.
//

import UIKit

final class Toast {
    /// 显示 toast 提示信息
    static func show(_ message: String, duration: TimeInterval = 2.0) {
        guard let window = UIApplication.shared.windows.first else {
            return
        }

        let toastLabel = UILabel().then {
            $0.backgroundColor = UIColor(0x000000, 0xFFFFFF).withAlphaComponent(0.5)
            $0.textColor = .white
            $0.font = .systemFont(ofSize: 15)
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.alpha = 0
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
            $0.text = message
        }

        window.addSubview(toastLabel)

        toastLabel.layout(maxWidth: window.bounds.width - 40.0 * 2) {
            let width = $0.width + 32
            let height = $0.height + 16
            return CGRect((window.bounds.width - width) / 2, (window.bounds.height - height) / 2, width, height)
        }

        UIView.animate(withDuration: 0.3, animations: {
            toastLabel.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.3,
                           delay: duration,
                           options: .curveEaseOut,
                           animations: {
                toastLabel.alpha = 0
            }) { _ in
                toastLabel.removeFromSuperview()
            }
        }
    }
}
