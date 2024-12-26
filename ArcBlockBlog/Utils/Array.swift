//
//  Array.swift
//  ArcBlockBlog
//
//  Created by Jiang Zhuoyi on 26/12/2024.
//

extension Array {
    /// 取值之前做判断，如果越界返回 nil
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
