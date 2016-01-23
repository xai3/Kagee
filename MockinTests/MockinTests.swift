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
    
    func testRequest() {
        let ex = expectationWithDescription("")
        
        Mock.up().request(url: "/").response(300, data: nil, header: nil)
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let request = NSURLRequest(URL: NSURL(string: "/")!)
        let session = NSURLSession(configuration: config)
        let task = session.dataTaskWithRequest(request) { data, response, error in
            guard let httpResponse = response as? NSHTTPURLResponse else {
                fatalError()
            }
            XCTAssertEqual(httpResponse.statusCode, 500)
            ex.fulfill()
        }
        task.resume()
        
        waitForExpectationsWithTimeout(1000) { error in
        }
    }
    
}
