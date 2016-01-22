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
    
}
