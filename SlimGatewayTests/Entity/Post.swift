//
//  Post.swift
//  SlimGatewayTests
//
//  Created by Juanjo García Villaescusa on 15/9/18.
//  Copyright © 2018 Juanjo García Villaescusa. All rights reserved.
//

struct Post {
    let postId: Int
    let userId: Int
    let title: String
    let body: String
}

extension Post {
    init?(json: JSONDictionary) {
        guard let postId = json["id"] as? Int,
            let userId = json["userId"] as? Int,
            let title = json["title"] as? String,
            let body = json["body"] as? String else { return nil }
        self.postId = postId
        self.userId = userId
        self.title = title
        self.body = body
    }
}
