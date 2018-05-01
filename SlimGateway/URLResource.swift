//
//  URLResource.swift
//  SlimGateway
//
//  Created by Juanjo García Villaescusa on 1/5/18.
//  Copyright © 2018 Juanjo García Villaescusa. All rights reserved.
//

public enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public struct URLResource<T> {
    public var url: URL
    public var httpMethod: HttpMethod
    public var params: [String: Any]?
    public var timeOut: TimeInterval
    public var parse: (Any) -> T?
}

extension URLResource {
    public init(url: URL, parse: @escaping (Any) -> T?) {
        self.url = url
        self.httpMethod = .get
        self.params = nil
        self.timeOut = TimeInterval.shortTimeOut
        self.parse = parse
    }
}
