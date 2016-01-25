//
//  MockinTests.swift
//  MockinTests
//
//  Created by yukiasai on 2016/01/23.
//  Copyright © 2016年 yukiasai. All rights reserved.
//

import XCTest
@testable import Mockin

class MockinTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        MockProtocol.register()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testUpDown() {
        let initialCount = Mock.pool.count
        let mock = Mock.up()
        XCTAssertEqual(Mock.pool.count, initialCount + 1)
        mock.down()
        XCTAssertEqual(Mock.pool.count, initialCount)
    }
    
    func testGetRequest() {
        let ex = expectationWithDescription("")
        
        let url = "/"
        Mock.up().request(url: url).response(200, data: nil, header: nil)
        
        let request = NSURLRequest(URL: NSURL(string: url)!)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        session.dataTaskWithRequest(request) { data, response, error in
            guard let httpResponse = response as? NSHTTPURLResponse else {
                fatalError()
            }
            XCTAssertEqual(httpResponse.statusCode, 200)
            ex.fulfill()
        }.resume()
        
        waitForExpectationsWithTimeout(1000) { error in
        }
    }
    
    func testGetJSON() {
        let ex = expectationWithDescription("")
        
        let url = "/json"
        let json: [String: AnyObject] = ["name": "yukiasai", "age": 28]
        Mock.up().request(url: url).response(200, json: json, header: nil)
        
        let request = NSURLRequest(URL: NSURL(string: url)!)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        session.dataTaskWithRequest(request) { data, response, error in
            guard let httpResponse = response as? NSHTTPURLResponse, let responseData = data else {
                fatalError()
            }
            XCTAssertEqual(httpResponse.statusCode, 200)
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(responseData, options: .AllowFragments)
                let dic = json as? [String: AnyObject]
                XCTAssertNotNil(dic)
                XCTAssertEqual(dic?["name"] as? String, "yukiasai")
                XCTAssertEqual(dic?["age"] as? Int, 28)
            } catch {
                fatalError()
            }
            
            ex.fulfill()
        }.resume()
        
        waitForExpectationsWithTimeout(1000) { error in
        }
    }
    
    func testGetError() {
        let ex = expectationWithDescription("")
        
        let url = "/error"
        let error = NSError(domain: "yukiasai.Mockin", code: 1000, userInfo: nil)
        Mock.up().request(url: url).response(error)
        
        let request = NSURLRequest(URL: NSURL(string: url)!)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        session.dataTaskWithRequest(request) { data, response, error in
            XCTAssertNil(data)
            XCTAssertNil(response)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.domain, "yukiasai.Mockin")
            XCTAssertEqual(error?.code, 1000)
            ex.fulfill()
        }.resume()
        
        waitForExpectationsWithTimeout(1000) { error in
        }
    }
    
    func testRequestHandlerSuccess() {
        let ex = expectationWithDescription("")
        
        let url = "/handler_success"
        Mock.up().request(url: url).response { request -> Response in
            let response = NSHTTPURLResponse(URL: request.URL!, statusCode: 200, HTTPVersion: nil, headerFields: nil)!
            let data = "12345".dataUsingEncoding(NSUTF8StringEncoding)
            return .Success(response, data)
        }
        
        let request = NSURLRequest(URL: NSURL(string: url)!)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        session.dataTaskWithRequest(request) { data, response, error in
            guard let httpResponse = response as? NSHTTPURLResponse, let responseData = data else {
                fatalError()
            }
            XCTAssertEqual(httpResponse.statusCode, 200)
            XCTAssertEqual(responseData.length, 5)
            
            ex.fulfill()
        }.resume()
        
        waitForExpectationsWithTimeout(1000) { error in }
    }
    
    func testRequestHandlerFailure() {
        let ex = expectationWithDescription("")
        
        let url = "/handler_failure"
        Mock.up().request(url: url).response { _ -> Response in
            let error = NSError(domain: "yukiasai.Mockin", code: 2000, userInfo: nil)
            return .Failure(error)
        }
        
        let request = NSURLRequest(URL: NSURL(string: url)!)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        session.dataTaskWithRequest(request) { data, response, error in
            XCTAssertNil(data)
            XCTAssertNil(response)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.domain, "yukiasai.Mockin")
            XCTAssertEqual(error?.code, 2000)
            ex.fulfill()
        }.resume()
        
        waitForExpectationsWithTimeout(1000) { error in }
    }
    
}
