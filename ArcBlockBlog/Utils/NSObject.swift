//
//  NSObject.swift
//  ArcBlockBlog
//
//  Created by Jiang Zhuoyi on 26/12/2024.
//

import Foundation
import ObjectiveC

extension NSObjectProtocol {
    /// 获取关联对象
    func getAssociatedObject(key: String = #function) -> Any? {
        objc_getAssociatedObject(self, Selector(key).utf8Start)
    }

    /// 设置关联对象
    func setAssociatedObject(_ value: Any?,
                             key: String = #function,
                             policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
        objc_setAssociatedObject(self, Selector(key).utf8Start, value, policy)
    }

    /// 懒加载形式创建关联对象
    func lazyVarAssociatedObject<T>(_ maker: () -> T, key: String = #function) -> T {
        (objc_getAssociatedObject(self, Selector(key).utf8Start) as? T) ?? {
            let object = maker()
            objc_setAssociatedObject(self, Selector(key).utf8Start, object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return object
        }()
    }
}

extension Selector {
    /// 获取 selector 全局唯一指针
    fileprivate var utf8Start: UnsafePointer<Int8> {
        unsafeBitCast(self, to: UnsafePointer<Int8>.self)
    }
}
