//
//  Album.swift
//  SlimGatewayTests
//
//  Created by Juanjo García Villaescusa on 31/10/2020.
//  Copyright © 2020 Juanjo García Villaescusa. All rights reserved.
//

import Foundation

struct Album {
    let id: Int
    let userId: Int
    let title: String
}

extension Album: Decodable {}
