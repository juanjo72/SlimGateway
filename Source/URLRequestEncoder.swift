//
//  URLEncoding.swift
//  SlimGateway
//
//  Created by Juanjo García Villaescusa on 2/9/18.
//  Copyright © 2018 Juanjo García Villaescusa. All rights reserved.
//

public protocol URLRequestEncoder {
    static func encode<T>(resource: URLResource<T>) -> URLRequest?
}

public final class URLQueryEncoder: URLRequestEncoder {
    public static func encode<T>(resource: URLResource<T>) -> URLRequest? {
        guard var urlComponents = URLComponents(url: resource.url, resolvingAgainstBaseURL: true) else { return nil }
        var userParams = [URLQueryItem]()
        if let parameters = resource.parameters {
            guard (parameters.values.allSatisfy { $0 is URLQueryRepresentable }) else { return nil }
            userParams = parameters.map { URLQueryItem(name: $0.key, value: ($0.value as? URLQueryRepresentable)?.urlParamValue) }
        }
        userParams += urlComponents.queryItems ?? []
        urlComponents.queryItems = userParams.isEmpty ? nil : userParams
        guard let url = urlComponents.url else { return nil }
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: resource.timeOut)
        request.httpMethod = resource.httpMethod.rawValue
        resource.httpHeaders?.forEach { header in
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
        return request
    }
}

public final class JSONBodyEncoder: URLRequestEncoder {
    public static func encode<T>(resource: URLResource<T>) -> URLRequest? {
        var request = URLRequest(url: resource.url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: resource.timeOut)
        request.httpMethod = resource.httpMethod.rawValue
        resource.httpHeaders?.forEach { header in
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
        guard let params = resource.parameters else { return request }
        guard let data = try? JSONSerialization.data(withJSONObject: params, options: []) else { return nil }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        return request
    }
}
