//
//  GatewayConfiguration.swift
//  SlimGateway
//
//  Created by Juanjo García Villaescusa on 6/5/18.
//  Copyright © 2018 Juanjo García Villaescusa. All rights reserved.
//

import Foundation

public struct GatewayConfiguration {
    let baseURL: URL?
    let authToken: String?
}

extension GatewayConfiguration {
    init(baseURL: URL?) {
        self.baseURL = baseURL
        self.authToken = nil
    }
    
    init() {
        self.baseURL = nil
        self.authToken = nil
    }
}

