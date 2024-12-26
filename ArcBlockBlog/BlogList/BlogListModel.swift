//
//  BlogListModel.swift
//  ArcBlockBlog
//
//  Created by Jiang Zhuoyi on 26/12/2024.
//

import Foundation

class BlogListModel: Codable {
    let cover: String
    let title: String
    let slug: String
    let publishTime: String
    let labels: [String]

    private static let iso8601DateFormatter = ISO8601DateFormatter().then {
        $0.formatOptions.insert(.withFractionalSeconds)
    }

    private static let dateFormatter = DateFormatter().then {
        $0.dateFormat = "yyyy年MM月dd日"
    }

    lazy var publishTimeText: String? = {
        guard let date = Self.iso8601DateFormatter.date(from: publishTime) else {
            return nil
        }
        return Self.dateFormatter.string(from: date)
    }()
}

struct BlogListResultModel: Codable {
    let total: Int
    let data: [BlogListModel]
}
