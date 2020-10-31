//
//  DefaultGatewayTests.swift
//  SlimGatewayTests
//
//  Created by Juanjo García Villaescusa on 6/5/18.
//  Copyright © 2018 Juanjo García Villaescusa. All rights reserved.
//

import XCTest
@testable import SlimGateway

class DefaultGatewayTests: XCTestCase {
    
    var gateway = SlimGateway()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testSlimGateway_whenResourceIsCorrect_shouldReturnEntities() {
        let expectation = self.expectation(description: "GET request")
        let url = URL(string: "https://jsonplaceholder.typicode.com/albums")!
        let resource = URLResource<[Album]>(url: url, httpMethod: .get) { data in
            try? JSONDecoder().decode([Album].self, from: data)
        }
        gateway.request(urlResource: resource) { result in
            switch result {
            case .success(let albums):
                XCTAssertTrue(albums.count == 100)
            case .failure:
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: .shortTimeOut)
    }
    
    func testSlimGateway_whenResourceIsIncorrect_shouldReturnInvalidResourceError() {
        let expectation = self.expectation(description: "GET request")
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        let resource = URLResource<[Album]>(url: url, httpMethod: .get) { data in
            try? JSONDecoder().decode([Album].self, from: data)
        }
        gateway.request(urlResource: resource) { result in
            if case let Result.failure(error) = result {
                if case GatewayError.invalidResource = error {} else {
                    XCTFail()
                }
            } else {
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: .shortTimeOut)
    }

    func testSlimGateway_whenAccessUnauthorized_shouldReturnAnauthorizedError() {
        let expectation = self.expectation(description: "Server access")
        let url = URL(string: "https://httpstat.us/401")!
        let resource = URLResource<[[String: Any]]>(url: url, httpMethod: .get) { data in
            try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
        }
        gateway.request(urlResource: resource) { result in
            if case let Result.failure(error) = result {
                if case GatewayError.unauthorized = error {} else {
                    XCTFail()
                }
            } else {
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: .shortTimeOut)
    }
    
    func testSlimGateway_whenServerError_shouldReturnServerError() {
        let expectation = self.expectation(description: "Server access")
        let url = URL(string: "https://httpstat.us/500")!
        let resource = URLResource<[[String: Any]]>(url: url, httpMethod: .get) { data in
            try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
        }
        gateway.request(urlResource: resource) { result in
            if case let Result.failure(error) = result {
                if case GatewayError.serverError = error {} else {
                    XCTFail("Should be Server Error")
                }
            } else {
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: .shortTimeOut)
    }
    
    func testSlimGateway_whenTimeOut_shouldReturnServerError() {
        let expectation = self.expectation(description: "Server access")
        let url = URL(string: "https://httpstat.us/200?sleep=1000")!
        let resource = URLResource<[[String: Any]]>(url: url, httpMethod: .get, timeOut: 0.5) { data in
            try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
        }
        gateway.request(urlResource: resource) { result in
            if case let Result.failure(error) = result {
                if case GatewayError.serverError = error {} else {
                    XCTFail("Should be Server Error")
                }
            } else {
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: .longTimeOut)
    }
}
