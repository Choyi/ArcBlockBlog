//
//  CacheManager.swift
//  ArcBlockBlog
//
//  Created by Jiang Zhuoyi on 27/12/2024.
//

import Foundation
import Cache

/// 缓存管理器
final class CacheManager {
    static let shared = CacheManager()

    private let storage: Storage<String, Data>?

    private init() {
        storage = try? Storage(diskConfig: DiskConfig(name: "CachedData", expiry: .seconds(60 * 60 * 24 * 7)),
                               memoryConfig: MemoryConfig(),
                               fileManager: .default,
                               transformer: TransformerFactory.forData())
    }

    /// 清除缓存
    func clear() {
        try? storage?.removeAll()
    }

    /// 设置缓存数据
    func setData(_ data: Data, forKey key: String) {
        do {
            try storage?.setObject(data, forKey: key)
        } catch {
            print("[CacheManager] Set cache error: \(error)")
        }
    }

    /// 获取缓存数据，并解码为指定的 Decodable 类型
    func codable<T: Decodable>(forKey key: String) -> T? {
        var model: T?
        do {
            if let data = try storage?.object(forKey: key) {
                model = try JSONDecoder().decode(T.self, from: data)
            }
        } catch {
            print("[CacheManager] Get cache error: \(error)")
        }
        return model
    }
}
