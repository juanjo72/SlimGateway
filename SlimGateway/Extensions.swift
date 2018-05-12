//
//  Extensions.swift
//  SlimGateway
//
//  Created by Juanjo García Villaescusa on 1/5/18.
//  Copyright © 2018 Juanjo García Villaescusa. All rights reserved.
//

import Foundation

extension TimeInterval {
    public static var shortTimeOut: TimeInterval {
        return 5
    }
    public static var longTimeOut: TimeInterval {
        return 10
    }
}

extension URLRequest {
    init<T>(resource: URLResource<T>, configuration: GatewayConfiguration? = nil) {
        var url = resource.url
        if let baseURL = configuration?.baseURL {
            url = baseURL.appendingPathComponent(resource.url.path)
        }
        self.init(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: resource.timeOut)
        if let token = configuration?.authToken {
            setValue(token, forHTTPHeaderField: "Authorization")
        }
    }
}
