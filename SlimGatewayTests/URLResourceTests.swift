//
//  URLRequestTests.swift
//  SlimGatewayTests
//
//  Created by Juanjo García Villaescusa on 1/5/18.
//  Copyright © 2018 Juanjo García Villaescusa. All rights reserved.
//

import XCTest
@testable import SlimGateway

class URLResourceTests: XCTestCase {
    
    var gateway: FileGateway!
    var resource: URLResource<HiAndGoodBye>!
    
    override func setUp() {
        super.setUp()
        // sample resource
        let url = Bundle(for: type(of: self)).url(forResource: "greeting", withExtension: "json")!
        resource = URLResource(url: url) { result in
            guard let json = result as? JSONDictionary else { return nil }
            return HiAndGoodBye(json: json)
        }
        gateway = FileGateway()
    }
    
    func testParse() {
        let expectation = self.expectation(description: "Correct parse")
        gateway.request(urlResource: resource) { result in
            XCTAssertTrue(result.isSuccessful)
            if let value = result.value {
                XCTAssertTrue(value.hi == "Hello world")
                XCTAssertTrue(value.goodbye == "Bye")
            } else {
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
}
