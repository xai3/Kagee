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
        
        let configClass = NSURLSessionConfiguration.self
        let originalMethod = class_getClassMethod(configClass, Selector("defaultSessionConfiguration"))
        let swizzledMethod = class_getClassMethod(configClass, Selector("mockSessionCongiguration"))
        method_exchangeImplementations(originalMethod, swizzledMethod)
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

extension NSURLSessionConfiguration {
    class func mockSessionCongiguration() -> NSURLSessionConfiguration {
        let config = mockSessionCongiguration()
        config.protocolClasses = ([MockProtocol.self] as [AnyClass]) + (config.protocolClasses ?? [])
        return config
    }
}
