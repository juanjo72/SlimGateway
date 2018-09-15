//
//  URLEncoding.swift
//  SlimGateway
//
//  Created by Juanjo García Villaescusa on 2/9/18.
//  Copyright © 2018 Juanjo García Villaescusa. All rights reserved.
//

public protocol ParametersEncoding {
    func encode<T>(resource: URLResource<T>) -> URLRequest?
}

public final class URLEncoding: ParametersEncoding {
    public func encode<T>(resource: URLResource<T>) -> URLRequest? {
        guard var urlComponents = URLComponents(url: resource.url, resolvingAgainstBaseURL: false) else { return nil }
        if let params = resource.parameters {
            let items = params.map { URLQueryItem(name: $0.key, value: $0.value.urlParamValue) }
            if let queryItems = urlComponents.queryItems {
                urlComponents.queryItems = queryItems + items
            } else {
                urlComponents.queryItems = items
            }
        }
        guard let url = urlComponents.url else { return nil }
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: resource.timeOut)
        request.httpMethod = resource.httpMethod.rawValue
        resource.httpHeaders?.forEach { header in
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
        return request
    }
}

public final class HttpBodyEncoding: ParametersEncoding {
    public func encode<T>(resource: URLResource<T>) -> URLRequest? {
        var request = URLRequest(url: resource.url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: resource.timeOut)
        resource.httpHeaders?.forEach { header in
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
        guard let params = resource.parameters else { return request }
        guard let data = try? JSONSerialization.data(withJSONObject: params, options: []) else { return nil }
        request.httpMethod = resource.httpMethod.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        return request
    }
}
