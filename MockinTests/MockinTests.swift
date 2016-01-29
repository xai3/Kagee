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
        let initialCount = MockPool.mocks.count
        let mock = Mock.up()
        XCTAssertEqual(MockPool.mocks.count, initialCount + 1)
        mock.down()
        XCTAssertEqual(MockPool.mocks.count, initialCount)
    }
    
    func testGetRequest() {
        let ex = expectationWithDescription("")
        
        let url = "/"
        Mock.up().request(url: url).response(200, body: nil, header: nil)
        
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
        Mock.up().request(url: url).response(200, body: JSON(json), header: nil)
        
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
    
    func testFile() {
        let ex = expectationWithDescription("")
        
        let url = "/json_file"
        let fileUrl = NSBundle(forClass: self.dynamicType).URLForResource("test", withExtension: "json")!
        Mock.up().request(url: url).response(200, body: File(fileUrl), header: nil)
        
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
        
        waitForExpectationsWithTimeout(1000) { error in }
    }
    
    
    func testString() {
        let ex = expectationWithDescription("")
        
        let url = "/plain_text"
        Mock.up().request(url: url).response(200, body: "{\"name\": \"yukiasai\", \"age\": 28}", header: nil)
        
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
        
        waitForExpectationsWithTimeout(1000) { error in }
    }
    
    func testPlainText() {
        let ex = expectationWithDescription("")
        
        let url = "/plain_text"
        Mock.up().request(url: url).response(200, body: Text("{\"name\": \"yukiasai\", \"age\": 28}"), header: nil)
        
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
        
        waitForExpectationsWithTimeout(1000) { error in }
    }
    
    func testURLConvertible() {
        let ex = expectationWithDescription("")
        
        let url = NSURL(string: "http://aaa.aaa")!
        Mock.up().request(url: url).response(200, body: nil, header: nil)
        
        let request = NSURLRequest(URL: url)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        session.dataTaskWithRequest(request) { data, response, error in
            guard let httpResponse = response as? NSHTTPURLResponse else {
                fatalError()
            }
            XCTAssertEqual(httpResponse.statusCode, 200)
            ex.fulfill()
        }.resume()
        
        waitForExpectationsWithTimeout(1000) { error in }
    }
    
    func testNetworkSpeed() {
        let ex = expectationWithDescription("")
        
        let url = "/network_speed"
        let data = (0..<100_000).reduce("") { sum, _ in return sum + "0" }.dataUsingEncoding(NSUTF8StringEncoding)!
        Mock.up().request(url: url).response(200, body: data, header: nil).speed(.Mobile3G)
        
        let request = NSURLRequest(URL: NSURL(string: url)!)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        session.dataTaskWithRequest(request) { data, response, error in
            guard let httpResponse = response as? NSHTTPURLResponse else {
                fatalError()
            }
            XCTAssertEqual(httpResponse.statusCode, 200)
            ex.fulfill()
        }.resume()
        
        waitForExpectationsWithTimeout(1000) { error in }
    }
    
}
