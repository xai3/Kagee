//
//  MockProtocol.swift
//  Mockin
//
//  Created by yukiasai on 2016/01/23.
//  Copyright © 2016年 yukiasai. All rights reserved.
//

import Foundation

public class MockProtocol: NSURLProtocol {
    static var token: dispatch_once_t = 0
    public class func register() {
        dispatch_once(&token) {
            NSURLProtocol.registerClass(self)
            
            let configClass = NSURLSessionConfiguration.self
            let originalMethod = class_getClassMethod(configClass, Selector("defaultSessionConfiguration"))
            let swizzledMethod = class_getClassMethod(configClass, Selector("mockSessionCongiguration"))
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
    
    public override class func canInitWithRequest(request: NSURLRequest) -> Bool {
        return targetMock(request) != nil
    }
    
    public override class func canonicalRequestForRequest(request: NSURLRequest) -> NSURLRequest {
        return request
    }
    
    public override func startLoading() {
        guard let mock = MockProtocol.targetMock(request) else {
            // Should nonnull is returned by the canInitWithRequest
            fatalError()
        }
        
        
        guard let response = mock.response else {
            fatalError()
        }
        
        switch response {
        case .Failure(let error):
            client?.URLProtocol(self, didFailWithError: error)
            return
        case .Success(let response, let data):
            client?.URLProtocol(self, didReceiveResponse: response, cacheStoragePolicy: .NotAllowed)
            if let d = data {
                client?.URLProtocol(self, didLoadData: d)
            }
            client?.URLProtocolDidFinishLoading(self)
        }
    }
    
    public override func stopLoading() {
    }
    
    private class func targetMock(request: NSURLRequest) -> Mock? {
        return Mock.pool.filter {
            let mockURL = $0.request?.URL
            let requestURL = request.URL
            return (mockURL?.host == requestURL?.host) && (mockURL?.path == requestURL?.path)
            }.last
    }
}

extension NSURLSessionConfiguration {
    class func mockSessionCongiguration() -> NSURLSessionConfiguration {
        let config = mockSessionCongiguration()
        config.protocolClasses = ([MockProtocol.self] as [AnyClass]) + (config.protocolClasses ?? [])
        return config
    }
}
