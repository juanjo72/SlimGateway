//
//  DefaultGateway.swift
//  SlimGateway
//
//  Created by Juanjo García Villaescusa on 6/5/18.
//  Copyright © 2018 Juanjo García Villaescusa. All rights reserved.
//

import Foundation

public final class SlimGateway {
    
    // MARK: Public Properties
    
    public var debug: Bool = false
    
    // MARK: Private Properties
    
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
    
    // MARK: Public Methods
    
    /**
     Requests a resource from its url.
     
     - parameter urlResource: Resource to load.
     - parameter completionQueue: Dispatch queue where results should be sent.
     - parameter completion: Completion callback.
     */
    public func request<T>(urlResource: URLResource<T>, completionQueue: DispatchQueue = DispatchQueue.main, completion: @escaping (Result<T, GatewayError>) -> Void) {
        
        let isDebugging = self.debug
        let requestEncoder = urlResource.encoder ?? urlResource.httpMethod.defaultEncoder
        guard let urlRequest = requestEncoder.encode(resource: urlResource) else {
            completion(.failure(GatewayError.invalidResource))
            return
        }
        
        if isDebugging {
            print("👻 \(urlRequest)")
        }
        
        session.dataTask(with: urlRequest) { data, response, error in
            var result: Result<T, GatewayError>?
            
            defer {
                completionQueue.async {
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
                if isDebugging {
                    print("💀 \(error.localizedDescription)")
                }
                return
            }
            if let response = response as? HTTPURLResponse, response.statusCode >= 400 {
                if response.statusCode == 401 {
                    result = .failure(GatewayError.unauthorized)
                } else if let data = data,
                          let details = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    result = .failure(GatewayError.endPointError(details))
                } else {
                    result = .failure(GatewayError.serverError)
                }
                if isDebugging {
                    print("💀 \(response)")
                }
                return
            }
            
            // decoding
            if let data = data {
                if let value = urlResource.decoder(data) {
                    result = .success(value)
                } else {
                    result = .failure(.invalidResource)
                }
                return
            }
            
            result = .failure(GatewayError.serverError)
        }
        .resume()
    }
}
