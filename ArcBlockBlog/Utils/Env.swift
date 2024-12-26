//
//  Env.swift
//  ArcBlockBlog
//
//  Created by Jiang Zhuoyi on 27/12/2024.
//

import Foundation

/// 环境配置
class Env {
    static let shared = Env()

    private var apiBaseURL = "https://www.arcblock.io"

    private var imageBaseURL = "https://www.arcblock.io/blog/uploads"

    /// 生成完整的 API URL
    func makeApiURL(_ path: String) -> String {
        if path.hasPrefix("http") {
            return path
        }
        let cleanPath = path.hasPrefix("/") ? String(path.dropFirst()) : path
        return "\(apiBaseURL)/\(cleanPath)"
    }

    /// 生成完整的图片 URL
    func makeImageURL(_ path: String) -> String {
        if path.hasPrefix("http") {
            return path
        }
        let cleanPath = path.hasPrefix("/") ? String(path.dropFirst()) : path
        return "\(imageBaseURL)/\(cleanPath)"
    }
}
