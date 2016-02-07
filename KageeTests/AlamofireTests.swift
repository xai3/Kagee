//
//  AlamofireTests.swift
//  Kagee
//
//  Created by yukiasai on 2/1/16.
//  Copyright © 2016 yukiasai. All rights reserved.
//

import XCTest
import Alamofire
@testable import Kagee

class AlamofireTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        MockProtocol.register()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGet() {
        let ex = expectationWithDescription("")
        
        let url = "/"
        Mock.install().request(url: url).response(200, body: nil, header: nil)
        Alamofire.request(.GET, url).response { _, response, _, _ in
            XCTAssertEqual(response?.statusCode, 200)
            ex.fulfill()
        }
        
        waitForExpectationsWithTimeout(1000) { error in }
    }
    
    func testJSON() {
        let ex = expectationWithDescription("")
        
        let url = "/json"
        let json: [String: AnyObject] = ["name": "yukiasai", "age": 28]
        Mock.install().request(url: url).response(200, body: JSON(json), header: nil)
        Alamofire.request(.GET, url).responseJSON { response in
            switch response.result {
            case .Success(let json):
                guard let dic = json as? [String: AnyObject] else {
                    XCTFail()
                    return
                }
                XCTAssertEqual(dic["name"] as? String, "yukiasai")
                XCTAssertEqual(dic["age"] as? Int, 28)
            case .Failure(_):
                XCTFail()
            }
            
            ex.fulfill()
        }
        
        waitForExpectationsWithTimeout(1000) { error in }
    }
    
}
