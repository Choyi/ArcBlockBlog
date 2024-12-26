//
//  BlogListApi.swift
//  ArcBlockBlog
//
//  Created by Jiang Zhuoyi on 26/12/2024.
//

import Foundation

enum BlogListApi {
    private static let blogListPath = "/blog/api/blogs"

    /// 从缓存加载列表数据
    static func fetchBlogListFromCache() -> BlogListResultModel? {
        return CacheManager.shared.codable(forKey: blogListPath)
    }

    /// 加载列表数据
    static func fetchBlogList(page: Int, size: Int = 20) async throws -> BlogListResultModel {
        var options: [RequestOptions] = []
        if page == 1 {
            // 将第一页数据缓存
            options.append(.cache(key: blogListPath))
        }

        return try await NetworkManager.shared.request(
            blogListPath,
            method: .get,
            parameters: [
                "page": page,
                "size": size,
                "locale": "zh"
            ],
            options: options
        )
    }
}
