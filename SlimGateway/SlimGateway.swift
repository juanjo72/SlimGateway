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
        let session = URLSession.init(configuration: sessionConfiguration, delegate: nil, delegateQueue: nil)
        return session
    }()
    
    public init() {}
    
    // MARK: Gateway
    
    /**
     Requests a resource from its url.
     
     - parameter urlResource: Resource to load.
     - parameter completion: Completion callback.
     */
    public func request<T>(urlResource: URLResource<T>, completion: ((URLResult<T>) -> Void)?) {
        
        let encoder = urlResource.encoder ?? urlResource.httpMethod.defaultEncoder
        guard let urlRequest = encoder.encode(resource: urlResource) else {
            completion?(.failure(GatewayError.invalidResource))
            return
        }
        
        session.dataTask(with: urlRequest) { data, _, error in
            var result: URLResult<T>?
            defer {
                DispatchQueue.main.async {
                    guard let result = result else { return }
                    completion?(result)
                }
            }
            if let error = error {
                if (error as NSError).code == .noConnection {
                    result = .failure(GatewayError.noConnection)
                } else {
                    result = .failure(GatewayError.serverError)
                }
                return
            }
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []),
                    let resource = urlResource.parse(json) {
                    result = .success(resource)
                } else {
                    result = .failure(GatewayError.unexpectedResponse)
                }
            }
        }
        .resume()
    }
}

