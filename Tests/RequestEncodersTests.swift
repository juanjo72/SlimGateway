//
//  RequestEncodersTests.swift
//  SlimGatewayTests
//
//  Created by Juanjo García Villaescusa on 30/10/2020.
//  Copyright © 2020 Juanjo García Villaescusa. All rights reserved.
//

import XCTest
@testable import SlimGateway

class RequestEncodersTests: XCTestCase {
    func testURLRequestEncoder_whenNoParams_returnRequest() {
        let url = URL(string: "https://jsonplaceholder.typicode.com/albums")!
        let resource = URLResource<[Album]>(url: url, httpMethod: .get) { data in
            try? JSONDecoder().decode([Album].self, from: data)
        }
        let request = URLQueryEncoder.encode(resource: resource)
        XCTAssertNotNil(request)
        XCTAssertEqual(request?.url, url)
        XCTAssertEqual(request?.httpMethod, "GET")
        XCTAssertNil(request?.httpBody)
        XCTAssertEqual(request?.allHTTPHeaderFields?.count, 0)
        XCTAssertEqual(request?.cachePolicy, .reloadIgnoringLocalCacheData)
    }
    
    func testURLRequestEncoder_whenParams_returnRequest() {
        let url = URL(string: "https://jsonplaceholder.typicode.com/albums")!
        let params = ["userId": [1234, 3453]]
        let resource = URLResource<[Album]>(url: url, httpMethod: .get, parameters: params) { data in
            try? JSONDecoder().decode([Album].self, from: data)
        }
        let request = URLQueryEncoder.encode(resource: resource)
        XCTAssertNotNil(request)
        XCTAssertNotEqual(request?.url, url)
        XCTAssertEqual(request?.url?.query, "userId=1234,3453")
        XCTAssertEqual(request?.allHTTPHeaderFields?.count, 0)
        XCTAssertEqual(request?.cachePolicy, .reloadIgnoringLocalCacheData)
    }
    
    func testURLRequestEncoder_whenWrongParams_returnRequest() {
        let url = URL(string: "https://jsonplaceholder.typicode.com/albums")!
        let params = ["userId": Album(id: 1, userId: 1, title: "Hello")]
        let resource = URLResource<[Album]>(url: url, parameters: params) { data in
            try? JSONDecoder().decode([Album].self, from: data)
        }
        let request = URLQueryEncoder.encode(resource: resource)
        XCTAssertNil(request)
    }
    
    func testURLRequestEncoder_whenHeaders_returnRequest() {
        let url = URL(string: "https://jsonplaceholder.typicode.com/albums")!
        let headers = ["Authorization": "Bearer abcdefghijk"]
        let resource = URLResource<[Album]>(url: url, httpHeaders: headers) { data in
            try? JSONDecoder().decode([Album].self, from: data)
        }
        let request = URLQueryEncoder.encode(resource: resource)
        XCTAssertNotNil(request)
        XCTAssertEqual(request?.allHTTPHeaderFields?.count, 1)
        XCTAssertEqual(request?.allHTTPHeaderFields?.first?.key, "Authorization")
        XCTAssertEqual(request?.allHTTPHeaderFields?.first?.value, "Bearer abcdefghijk")
    }
}
