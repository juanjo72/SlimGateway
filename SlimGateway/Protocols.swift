//
//  Protocols.swift
//  SlimGateway
//
//  Created by Juanjo García Villaescusa on 1/5/18.
//  Copyright © 2018 Juanjo García Villaescusa. All rights reserved.
//

import Foundation

public protocol Gateway {
    func request<T>(resource: URLResource<T>, completion: ((Result<T>) -> Void)?)
}
