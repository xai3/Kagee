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
        let mock = Mock.up()
        XCTAssertEqual(Mock.pool.count, 1)
        mock.down()
        XCTAssertEqual(Mock.pool.count, 0)
    }
    
    func testRequest() {
        let ex = expectationWithDescription("")
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let request = NSURLRequest(URL: NSURL(string: "https//google.co.jp")!)
        let session = NSURLSession(configuration: config)
        let task = session.dataTaskWithRequest(request) { data, response, error in
            print(data)
            
            ex.fulfill()
        }
        task.resume()
        
        waitForExpectationsWithTimeout(1000) { error in
        }
    }
    
}
