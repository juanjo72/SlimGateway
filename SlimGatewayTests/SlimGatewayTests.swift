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
    
    var gateway: Gateway = SlimGateway()
    
    lazy var resource: URLResource<JSONDictionary> = {
        let url = Bundle(for: type(of: self)).url(forResource: "stations", withExtension: "json")!
        let resource = URLResource<JSONDictionary>(url: url) { response in
            guard let json = response as? JSONDictionary else { return nil }
            return json
        }
        return resource
    }()
    
    var apiKey: String {
        let file = Bundle(for: type(of: self)).path(forResource: "keys", ofType: "plist")!
        let keys = NSDictionary(contentsOfFile: file)!
        return keys["apikey"] as! String
    }
    
    override func setUp() {
        super.setUp()
    }
    
    func testRequest() {
        let expectation = self.expectation(description: "Gateway request")
        gateway.request(urlResource: resource) { result in
            switch result {
            case .success(let json):
                guard let stations = json["stations"] as? [JSONDictionary] else {
                    XCTFail()
                    return
                }
                XCTAssertTrue(stations.count == 463)
            case .failure:
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: TimeInterval.shortTimeOut)
    }
    
    func testAuthRequest() {
        let expectation = self.expectation(description: "Auth request")
        let url = URL(string: "https://api.xceed.me/b2c/v4/cities/44/events")!
        let params: Parameters = ["category": 1, "start": 0, "limit": 1]
        
        let httpHeaders = ["Authorization" : apiKey]
        let resource = URLResource<[JSONDictionary]>(url: url, httpHeaders: httpHeaders, parameters: params) { response in
            guard let json = response as? [JSONDictionary] else { return nil }
            return json
        }
        gateway.request(urlResource: resource) { result in
            switch result {
            case .success:
                break
            case .failure:
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: .shortTimeOut)
    }
    
    override func tearDown() {
        super.tearDown()
    }
}
