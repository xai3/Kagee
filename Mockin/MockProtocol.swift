//
//  MockProtocol.swift
//  Mockin
//
//  Created by yukiasai on 2016/01/23.
//  Copyright © 2016年 yukiasai. All rights reserved.
//

import Foundation

public class MockProtocol: NSURLProtocol {
    public class func register() {
        NSURLProtocol.registerClass(self)
    }
    
    public override class func canInitWithRequest(request: NSURLRequest) -> Bool {
        return true
    }
    
    public override class func canonicalRequestForRequest(request: NSURLRequest) -> NSURLRequest {
        return request
    }
    
    public override func startLoading() {
    }
    
    public override func stopLoading() {
    }
}
