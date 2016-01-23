//
//  Mock.swift
//  Mockin
//
//  Created by yukiasai on 2016/01/23.
//  Copyright © 2016年 yukiasai. All rights reserved.
//

import Foundation

public class Mock: MockType, MockRequestType, MockResponseType {
    static var pool = [Mock]()
    
    var request: NSURLRequest?
    var response: NSURLResponse?
    var data: NSData?
    
    public class func up() -> Mock {
        let mock = Mock()
        pool += [mock]
        return mock
    }
    
    public func down() {
        if let index = (Mock.pool.indexOf { $0 === self }) {
            Mock.pool.removeAtIndex(index)
        }
    }
    
    public func request(url urlConvertible: URLConvertible, method: Method = .GET) -> MockRequestType {
        let req = NSMutableURLRequest(URL: urlConvertible.URL)
        req.HTTPMethod = method.rawValue
        return request(req)
    }
    
    public func request(request: NSURLRequest) -> MockRequestType {
        self.request = request
        return self
    }

    public func response(statusCode: Int, data: NSData?, header: [String: String]?) -> MockResponseType {
        guard let url = request?.URL,
            let res = NSHTTPURLResponse(URL: url, statusCode: statusCode, HTTPVersion: nil, headerFields: header) else {
                fatalError()
        }
        return response(res, data: data)
    }
    
    public func response(response: NSURLResponse, data: NSData?) -> MockResponseType {
        self.response = response
        self.data = data
        return self
    }
}

public protocol MockType: class {
    func request(url urlConvertible: URLConvertible, method: Method) -> MockRequestType
    func request(request: NSURLRequest) -> MockRequestType
}

public protocol MockRequestType: class {
    func response(statusCode: Int, data: NSData?, header: [String: String]?) -> MockResponseType
    func response(response: NSURLResponse, data: NSData?) -> MockResponseType
}

public protocol MockResponseType: class {
}

public protocol URLConvertible {
    var URL: NSURL { get }
}

extension String: URLConvertible {
    public var URL: NSURL {
        guard let ret = NSURL(string: self) else {
            fatalError()
        }
        return ret
    }
}

public enum Method: String {
    case GET
    case POST
    case PUT
    case DELETE
}
