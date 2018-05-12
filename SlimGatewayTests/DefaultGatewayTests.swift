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
    
    lazy var resource: URLResource<JSONDictionary> = {
        let url = Bundle(for: type(of: self)).url(forResource: "stations", withExtension: "json")!
        let resource = URLResource<JSONDictionary>(url: url, httpMethod: .get, params: nil, timeOut: TimeInterval.shortTimeOut) { response in
            guard let json = response as? JSONDictionary else { return nil }
            return json
        }
        return resource
    }()
    
    var gateway: Gateway!
    
    override func setUp() {
        super.setUp()
        let config = GatewayConfiguration()
        gateway = DefaultGateway(configuration: config)
    }
    
    func testConfiguration() {
        let configuration = GatewayConfiguration(baseURL: URL(string: "http://wservice.viabicing.cat")!)
        let gateway = DefaultGateway(configuration: configuration)
        XCTAssertTrue(gateway.configuration?.baseURL?.absoluteString == "http://wservice.viabicing.cat")
        let tokenConfig = GatewayConfiguration(baseURL: gateway.configuration?.baseURL, authToken: "xxx")
        gateway.configuration = tokenConfig
        XCTAssertTrue(gateway.configuration?.authToken == "xxx")
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
        let baseURL = URL(string: "https://api.xceed.me")!
        let configuration = GatewayConfiguration(baseURL: baseURL, authToken: "eb46e449554e81b8beb3155313aaca")
        let gateway = DefaultGateway(configuration: configuration)
        let url = URL(string: "/b2c/v4/cities")!
        let resource = URLResource<[JSONDictionary]>(url: url, httpMethod: .get, params: nil, timeOut: TimeInterval.shortTimeOut) { response in
            guard let json = response as? [JSONDictionary] else {
                return nil
            }
            return json
        }
        gateway.request(urlResource: resource) { result in
            switch result {
            case .success(let json):
                XCTAssertTrue(json.count == 45)
            case .failure:
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: TimeInterval.shortTimeOut)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
}
