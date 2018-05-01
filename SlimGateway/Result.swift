//
//  Result.swift
//  SlimGateway
//
//  Created by Juanjo García Villaescusa on 1/5/18.
//  Copyright © 2018 Juanjo García Villaescusa. All rights reserved.
//

import Foundation

public enum Result<T> {
    case success(T)
    case failure(Error)
}

extension Result {
    public var isSuccessful: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    public var isFailure: Bool {
        switch self {
        case .success:
            return false
        case .failure:
            return true
        }
    }
}

extension Result {
    public var value: T? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
    
    public var error: Error? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}
