//
//  Route.swift
//  Kiwi Flight
//
//  Created by Thành Đỗ Long on 28/09/2019.
//  Copyright © 2019 Thành Đỗ Long. All rights reserved.
//

import Foundation

public typealias Parameters = [String: String]

protocol Route {
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
}

public enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
    case head = "HEAD"
    case options = "OPTIONS"
    case trace = "TRACE"
    case connect = "CONNECT"
}

extension Route {
    public func asURLComponents() throws -> URLComponents? {
        guard let url = URL(string: baseURL) else { throw NetworkError.badRequest }
        var urlComponents = URLComponents(url: url.appendingPathComponent(path), resolvingAgainstBaseURL: true)
        
        // Parameters
        if let parameters = parameters {
            do {
                if method == .get {
                    urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
                }
            }
        }
        
        return urlComponents
    }
}
