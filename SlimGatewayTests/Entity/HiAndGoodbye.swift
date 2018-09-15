//
//  HiAndGoodbye.swift
//  SlimGatewayTests
//
//  Created by Juanjo García Villaescusa on 1/5/18.
//  Copyright © 2018 Juanjo García Villaescusa. All rights reserved.
//

typealias JSONDictionary = [String: Any]

struct HiAndGoodBye {
    let hi: String
    let goodbye: String
}

extension HiAndGoodBye {
    init?(json: JSONDictionary) {
        guard let hi = json["greeting"] as? String,
            let goodbye = json["farewell"] as? String else {
                return nil
        }
        self.hi = hi
        self.goodbye = goodbye
    }
}
