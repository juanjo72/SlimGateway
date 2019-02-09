//
//  DefaultGateway.swift
//  SlimGateway
//
//  Created by Juanjo García Villaescusa on 6/5/18.
//  Copyright © 2018 Juanjo García Villaescusa. All rights reserved.
//

import Foundation

public protocol Gateway {
    func request<T>(urlResource: URLResource<T>, completion: @escaping (URLResult<T>) -> Void)
}

public final class SlimGateway: Gateway {
    
    // MARK: Properties
    
    private lazy var session: URLSession = {
        var sessionConfiguration: URLSessionConfiguration = {
            let config = URLSessionConfiguration.ephemeral
            return config
        }()
        let session = URLSession(configuration: sessionConfiguration)
        return session
    }()
    
    // MARK: Lifecycle
    
    public init() {}
    
    // MARK: Gateway
    
    /**
     Requests a resource from its url.
     
     - parameter urlResource: Resource to load.
     - parameter completion: Completion callback.
     */
    public func request<T>(urlResource: URLResource<T>, completion: @escaping (URLResult<T>) -> Void) {
        
        let encoder = urlResource.encoder ?? urlResource.httpMethod.defaultEncoder
        guard let urlRequest = encoder.encode(resource: urlResource) else {
            completion(.failure(GatewayError.invalidResource))
            return
        }
        
        session.dataTask(with: urlRequest) { data, response, error in
            var result: URLResult<T>?
            defer {
                DispatchQueue.main.async {
                    guard let result = result else { return }
                    completion(result)
                }
            }
            // detecting http errors
            if let error = error {
                if (error as NSError).code == .noConnection {
                    result = .failure(GatewayError.noConnection)
                } else {
                    result = .failure(GatewayError.serverError)
                }
                return
            }
            if let response = response as? HTTPURLResponse, response.statusCode >= 400 {
                if let data = data,
                    let json = try? JSONSerialization.jsonObject(with: data, options: []),
                    let details = json as? JSONDictionary  {
                    result = .failure(GatewayError.endPointError(details))
                } else {
                    result = .failure(GatewayError.serverError)
                }
                return
            }
            // parse error
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if let resource = urlResource.parse(json) {
                    result = .success(resource)
                } else {
                    result = .failure(GatewayError.invalidResource)
                }
                return
            }
            result = .failure(GatewayError.serverError)
            }
            .resume()
    }
}
