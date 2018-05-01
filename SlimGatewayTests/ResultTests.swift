//
//  ResultTests.swift
//  SlimGatewayTests
//
//  Created by Juanjo García Villaescusa on 1/5/18.
//  Copyright © 2018 Juanjo García Villaescusa. All rights reserved.
//

import XCTest
@testable import SlimGateway

class ResultTests: XCTestCase {
    enum ErrorType: Error {
        case test
    }
    
    func testSuccess() {
        let result: Result<Bool> = .success(true)
        XCTAssertTrue(result.isSuccessful)
        XCTAssertFalse(result.isFailure)
        XCTAssertTrue(result.value == true)
        XCTAssertNil(result.error)
    }
    
    func testFailure() {
        let result: Result<Bool> = .failure(ErrorType.test)
        XCTAssertTrue(result.isFailure)
        XCTAssertFalse(result.isSuccessful)
        XCTAssertNil(result.value)
        XCTAssertTrue(result.error?.localizedDescription == ErrorType.test.localizedDescription)
    }
}
