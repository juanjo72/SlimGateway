//
//  TestGateway.swift
//  SlimGatewayTests
//
//  Created by Juanjo García Villaescusa on 1/5/18.
//  Copyright © 2018 Juanjo García Villaescusa. All rights reserved.
//

import Foundation
import SlimGateway

class FileGateway: Gateway {
    enum GatewayError: Error {
        case notFileURL
        case unableToRead
        case invalidJSON
        case parseError
    }
    
    func request<T>(urlResource resource: URLResource<T>, completion: ((URLResult<T>) -> Void)?) {
        guard resource.url.isFileURL else {
            completion?(.failure(GatewayError.notFileURL))
            return
        }
        guard let data = try? Data(contentsOf: resource.url) else {
            completion?(.failure(GatewayError.unableToRead))
            return
        }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: [.allowFragments]) else {
            completion?(.failure(GatewayError.invalidJSON))
            return
        }
        if let value = resource.parse(json) {
            completion?(.success(value))
        } else {
            completion?(.failure(GatewayError.parseError))
        }
    }
}
