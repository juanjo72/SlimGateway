//
//  DefaultGateway.swift
//  SlimGateway
//
//  Created by Juanjo García Villaescusa on 6/5/18.
//  Copyright © 2018 Juanjo García Villaescusa. All rights reserved.
//

import Foundation

public final class DefaultGateway: Gateway {
    
    var configuration: GatewayConfiguration?
    
    private lazy var sessionConfiguration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.ephemeral
        return config
    }()
    
    private lazy var session: URLSession = {
        let session = URLSession(configuration: sessionConfiguration)
        return session
    }()

    
    // MARK: Lifecycle
    
    init(configuration: GatewayConfiguration? = nil) {
        self.configuration = configuration
    }
    
    // MARK: Public
    
    public func request<T>(urlResource: URLResource<T>, completion: ((Result<T>) -> Void)?) {
        let urlRequest = URLRequest(resource: urlResource, configuration: configuration)
        session.dataTask(with: urlRequest) { data, response, error in
            
            if let data = data {
                
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200 else {
                        completion?(.failure(GatewayError.serverError))
                        return
                }
                
                if let json = try? JSONSerialization.jsonObject(with: data, options: []),
                    let resource = urlResource.parse(json) {
                    completion?(.success(resource))
                } else {
                    completion?(.failure(GatewayError.unrecognizedFormat))
                }
                return
            }
            if let error = error {
                completion?(.failure(error))
            }
        }
        .resume()
    }
}

extension DefaultGateway {
    public enum GatewayError: Error {
        case serverError
        case unrecognizedFormat
    }
}
