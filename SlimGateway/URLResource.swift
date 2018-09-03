//
//  URLResource.swift
//  SlimGateway
//
//  Created by Juanjo García Villaescusa on 1/5/18.
//  Copyright © 2018 Juanjo García Villaescusa. All rights reserved.
//

public typealias Parameters = [String: URLQueryRepresentable]
public typealias HttpHeaders = [String: String]

public enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

extension HttpMethod {
    var defaultEncoding: ParametersEncoding {
        switch self {
        case .get, .delete:
            return URLEncoding()
        case .put, .post:
            return HttpBodyEncoding()
        }
    }
}

public struct URLResource<T> {
    public var url: URL
    public var httpMethod: HttpMethod
    public var httpHeaders: HttpHeaders?
    public var parameters: Parameters?
    public var parametersEncoding: ParametersEncoding?
    public var timeOut: TimeInterval
    public var parse: (Any) -> T?
    
    public init(url: URL, httpMethod: HttpMethod = .get, httpHeaders: HttpHeaders? = nil, parameters: Parameters? = nil, parametersEncoding: ParametersEncoding? = nil,  timeOut: TimeInterval = .shortTimeOut, parse: @escaping (Any) -> T?) {
        self.url = url
        self.httpMethod = httpMethod
        self.httpHeaders = httpHeaders
        self.parameters = parameters
        self.parametersEncoding = parametersEncoding
        self.timeOut = timeOut
        self.parse = parse
    }
}
