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
    case patch = "PATCH"
    case delete = "DELETE"
}

extension HttpMethod {
    var defaultEncoder: URLRequestEncoder.Type {
        switch self {
        case .get, .delete:
            return URLQueryEncoder.self
        case .put, .post, .patch:
            return JSONBodyEncoder.self
        }
    }
}

public struct URLResource<T> {
    public var url: URL
    public var httpMethod: HttpMethod
    public var httpHeaders: [String: String]?
    public var parameters: [String: Any]?
    public var encoder: URLRequestEncoder.Type?
    public var timeOut: TimeInterval
    public var decoder: (Data) -> T?
    
    public init(url: URL, httpMethod: HttpMethod = .get, httpHeaders: [String: String]? = nil, parameters: [String: Any]? = nil, encoder: URLRequestEncoder.Type? = nil, timeOut: TimeInterval = .shortTimeOut, decoder: @escaping (Data) -> T?) {
        self.url = url
        self.httpMethod = httpMethod
        self.httpHeaders = httpHeaders
        self.parameters = parameters
        self.encoder = encoder
        self.timeOut = timeOut
        self.decoder = decoder
    }
}
