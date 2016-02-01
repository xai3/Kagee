//
//  MockPool.swift
//  Kagee
//
//  Created by yukiasai on 1/29/16.
//  Copyright © 2016 yukiasai. All rights reserved.
//

import Foundation

public class MockPool {
    static var mocks = [Mock]()
    
    class func add(mock: Mock) {
        mocks += [mock]
    }
    
    class func remove(mock: Mock) {
        if let index = (mocks.indexOf { $0 === mock }) {
            mocks.removeAtIndex(index)
        }
    }
    
    class func targetMock(request: NSURLRequest) -> Mock? {
        return mocks.filter {
            let isEqualMethod = $0.request?.HTTPMethod == request.HTTPMethod
            let isEqualHost = $0.request?.URL?.host == request.URL?.host
            let isEqualPath = $0.request?.URL?.path == request.URL?.path
            return isEqualMethod && isEqualHost && isEqualPath
        }.last
    }
}
