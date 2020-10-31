//
//  ResourceTests.swift
//  SlimGatewayTests
//
//  Created by Juanjo García Villaescusa on 31/10/2020.
//  Copyright © 2020 Juanjo García Villaescusa. All rights reserved.
//

import XCTest
@testable import SlimGateway

class ResourceTests: XCTestCase {
    lazy var url: URL = {
        Bundle(for: ResourceTests.self).url(forResource: "albums", withExtension: "json")!
    }()
    
    lazy var data: Data = {
        try! Data(contentsOf: url)
    }()
    
    func testResource_whenCreated_shouldHaveCorrectMethod() throws {
        let resource = URLResource<[Album]>(url: url, httpMethod: .patch) { data in
            try? JSONDecoder().decode([Album].self, from: data)
        }
        XCTAssertEqual(resource.httpMethod, .patch)
    }
    
    func testResource_whenCreated_shouldHaveCorrectHeaders() throws {
        let headers = ["Authorization": "Bearer: abcdefghijk"]
        let resource = URLResource<[Album]>(url: url, httpHeaders: headers) { data in
            try? JSONDecoder().decode([Album].self, from: data)
        }
        XCTAssertEqual(resource.httpHeaders?["Authorization"], "Bearer: abcdefghijk")
    }

    func testResource_whenCorrect_shouldDecode() throws {
        let resource = URLResource<[Album]>(url: url) { data in
            try? JSONDecoder().decode([Album].self, from: data)
        }
        let albums = resource.decoder(data)
        XCTAssertNotNil(albums)
        XCTAssertEqual(albums?.count, 100)
    }
}
