//
//  DefaultGateway.swift
//  SlimGateway
//
//  Created by Juanjo García Villaescusa on 6/5/18.
//  Copyright © 2018 Juanjo García Villaescusa. All rights reserved.
//

import Foundation

public protocol Gateway {
    func request<T>(urlResource: URLResource<T>, completion: ((URLResult<T>) -> Void)?)
}

public final class SlimGateway: Gateway {
    
    private lazy var sessionConfiguration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.ephemeral
        return config
    }()
    
    private lazy var session: URLSession = {
        let session = URLSession(configuration: sessionConfiguration)
        return session
    }()
    
    public init() {}
    
    // MARK: Gateway
    
    public func request<T>(urlResource: URLResource<T>, completion: ((URLResult<T>) -> Void)?) {
        
        let encoding = urlResource.parametersEncoding ?? urlResource.httpMethod.defaultEncoding
        guard let urlRequest = encoding.encode(resource: urlResource) else {
            completion?(.failure(GatewayError.invalidResource))
            return
        }
        
        session.dataTask(with: urlRequest) { data, _, error in
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []),
                    let resource = urlResource.parse(json) {
                    completion?(.success(resource))
                } else {
                    completion?(.failure(GatewayError.unrecognizedFormat))
                }
                return
            }
            if let _ = error {
                completion?(.failure(GatewayError.serverError))
            }
        }
        .resume()
    }
}

extension SlimGateway {
    public enum GatewayError: Error {
        case invalidResource
        case serverError
        case unrecognizedFormat
    }
}
