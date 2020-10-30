//
//  GatewayError.swift
//  SlimGateway
//
//  Created by Juanjo García Villaescusa on 24/9/18.
//  Copyright © 2018 Juanjo García Villaescusa. All rights reserved.
//

internal typealias ErrorCode = Int

extension ErrorCode {
    static var noConnection: ErrorCode {
        return -1009
    }
}

public enum GatewayError: Error {
    case noConnection
    case unauthorized
    case serverError
    case invalidResource
    case endPointError([String: Any])
}

extension GatewayError: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .noConnection:
            return "No Internet"
        case .unauthorized:
            return "Unauthorized access"
        case .serverError:
            return "Server Error"
        case .invalidResource:
            return "Invalid Resource"
        case .endPointError(let details):
            return details.description
        }
    }
}
