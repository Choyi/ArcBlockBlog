//
//  UICollectionView.swift
//  ArcBlockBlog
//
//  Created by Jiang Zhuoyi on 26/12/2024.
//

import UIKit

extension UICollectionView {
    /// 注册 cell 类，identifier 为类名
    func registerCell<T: UICollectionViewCell>(_ type: T.Type) {
        let identifier = NSStringFromClass(type.self)
        register(type, forCellWithReuseIdentifier: identifier)
    }

    /// 批量注册 cell 类，identifier 为类名
    func registerCells(_ types: [AnyClass]) {
        types.forEach {
            if let type = $0 as? UICollectionViewCell.Type {
                registerCell(type)
            } else {
                assertionFailure()
            }
        }
    }

    /// 通过类名获取注册的 cell
    func dequeueReusableCell<T: UICollectionViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T {
        let identifier = NSStringFromClass(type.self)
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("\(type.self) was not registered")
        }
        return cell
    }
}
