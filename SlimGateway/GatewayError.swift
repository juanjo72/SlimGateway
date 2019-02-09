//
//  GatewayError.swift
//  SlimGateway
//
//  Created by Juanjo García Villaescusa on 24/9/18.
//  Copyright © 2018 Juanjo García Villaescusa. All rights reserved.
//

public typealias ErrorDetails = JSONDictionary
internal typealias ErrorCode = Int

extension ErrorCode {
    static var noConnection: ErrorCode {
        return -1009
    }
}

public enum GatewayError: Error {
    case noConnection
    case serverError
    case invalidResource
    case endPointError(ErrorDetails)
}
