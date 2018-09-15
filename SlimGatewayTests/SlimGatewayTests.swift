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
        let url = Bundle(for: type(of: self)).url(forResource: "stations", withExtension: "json")!
        let resource = URLResource<JSONDictionary>(url: url) { response in
            guard let json = response as? JSONDictionary else { return nil }
            return json
        }
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
        let url = URL(string: "https://samples.openweathermap.org/data/2.5/forecast")!
        var params = Parameters()
        params["q"] = "London,uk"
        params["appid"] = apiKey
        let resource = URLResource<JSONDictionary>(url: url, parameters: params) { response in
            guard let json = response as? JSONDictionary else { return nil }
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
    
    func testGET() {
        let expectation = self.expectation(description: "GET request")
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        let postsResource = URLResource<[Post]>(url: url, httpMethod: .get) { response in
            guard let json = response as? [JSONDictionary] else { return nil }
            return json.compactMap(Post.init)
        }
        gateway.request(urlResource: postsResource) { result in
            switch result {
            case .success(let posts):
                XCTAssertTrue(posts.count == 100)
            case .failure:
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: .shortTimeOut)
    }
    
    func testPOST() {
        let expectation = self.expectation(description: "POST request")
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        var post = Parameters.init()
        post["userId"] = 1
        post["title"] = "foo"
        post["body"] = "bar"
        let newPostResource = URLResource<Post>(url: url, httpMethod: .post, parameters: post, parametersEncoding: HttpBodyEncoding()) { result in
            guard let json = result as? JSONDictionary else { return nil }
            return Post(json: json)
        }
        gateway.request(urlResource: newPostResource) { result in
            switch result {
            case .success(let post):
                XCTAssertTrue(post.postId == 101)
                XCTAssertTrue(post.userId == 1)
            case .failure:
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: .shortTimeOut)
    }
    
    func testPUT() {
        let expectation = self.expectation(description: "PUT request")
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1")!
        var postToUpdate = Parameters.init()
        postToUpdate["id"] = 1
        postToUpdate["userId"] = 1
        postToUpdate["title"] = "foo"
        postToUpdate["body"] = "bar"
        let newPostResource = URLResource<Post>(url: url, httpMethod: .put, parameters: postToUpdate) { result in
            guard let json = result as? JSONDictionary else { return nil }
            return Post(json: json)
        }
        gateway.request(urlResource: newPostResource) { result in
            switch result {
            case .success(let post):
                XCTAssertTrue(post.postId == 1)
                XCTAssertTrue(post.userId == 1)
            case .failure:
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: .shortTimeOut)
    }
    
    func testDELETE() {
        let expectation = self.expectation(description: "DELETE request")
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1")!
        let newPostResource = URLResource<Bool>(url: url, httpMethod: .delete) { result in
            guard let _ = result as? JSONDictionary else { return nil }
            return true
        }
        gateway.request(urlResource: newPostResource) { result in
            if result.isFailure {
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
