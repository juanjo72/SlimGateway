//
//  GatewayError.swift
//  SlimGateway
//
//  Created by Juanjo García Villaescusa on 24/9/18.
//  Copyright © 2018 Juanjo García Villaescusa. All rights reserved.
//

typealias ErrorCode = Int

extension ErrorCode {
    static var noConnection: ErrorCode {
        return -1009
    }
}

public enum GatewayError: Error {
    case invalidResource
    case serverError
    case unexpectedResponse
    case noConnection
}
