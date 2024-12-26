//
//  NetworkManager.swift
//  ArcBlockNews
//
//  Created by Jiang Zhuoyi on 26/12/2024.
//

import Foundation
import Alamofire

enum RequestOptions {
    /// 是否将接口响应缓存
    case cache(key: String)
}

enum NetworkError: Error {
    case serverError(Int)
    case unknown(Error)
}

/// 网络管理器
final class NetworkManager {
    static let shared = NetworkManager()

    private let session: Session

    private let defaultHeaders: HTTPHeaders = [:]

    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        session = Session(configuration: configuration)
    }

    /// 请求接口
    func request<T: Decodable>(
        _ path: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil,
        options: [RequestOptions] = []
    ) async throws -> T {
        let url = Env.shared.makeApiURL(path)

        return try await withCheckedThrowingContinuation { continuation in
            session.request(
                url,
                method: method,
                parameters: parameters,
                encoding: encoding,
                headers: defaultHeaders.merging(headers)
            )
            .validate(statusCode: 200..<300)
            .responseData { resp in
                options.forEach {
                    switch $0 {
                    case .cache(let key):
                        if let data = resp.data {
                            CacheManager.shared.setData(data, forKey: key)
                        }
                    }
                }
            }
            .responseDecodable(of: T.self) { resp in
                switch resp.result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    if let statusCode = resp.response?.statusCode {
                        continuation.resume(throwing: NetworkError.serverError(statusCode))
                    } else {
                        continuation.resume(throwing: NetworkError.unknown(error))
                    }
                }
            }
        }
    }
}

extension HTTPHeaders {
    /// 合并请求头字段
    fileprivate func merging(_ otherHeader: HTTPHeaders?) -> HTTPHeaders {
        guard let otherHeader else {
            return self
        }
        var result = self
        otherHeader.forEach {
            result.update($0)
        }
        return result
    }
}
