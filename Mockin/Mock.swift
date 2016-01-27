//
//  Mock.swift
//  Mockin
//
//  Created by yukiasai on 2016/01/23.
//  Copyright © 2016年 yukiasai. All rights reserved.
//

import Foundation

public typealias Header = [String: String]

public class Mock: MockType, MockRequestType, MockResponseType {
    public typealias RequestHandler = Void -> NSURLRequest
    public typealias ResponseHandler = NSURLRequest -> Response
    
    let errorDomain = "yukiasai.Mockin"
    
    static var pool = [Mock]()
    
    var requestHandler: RequestHandler?
    var request: NSURLRequest? {
        return requestHandler?()
    }
    
    var responseHandler: ResponseHandler?
    var response: Response? {
        return responseHandler?(request!)
    }
}

extension Mock {
    public class func up() -> MockType {
        let mock = Mock()
        pool += [mock]
        return mock
    }
    
    public func down() {
        if let index = (Mock.pool.indexOf { $0 === self }) {
            Mock.pool.removeAtIndex(index)
        }
    }
}

extension Mock {
    public func request(url urlConvertible: URLConvertible) -> MockRequestType {
        return request(url: urlConvertible, method: .GET)
    }
    
    public func request(url urlConvertible: URLConvertible, method: Method) -> MockRequestType {
        let req = NSMutableURLRequest(URL: urlConvertible.URL)
        req.HTTPMethod = method.rawValue
        return request(req)
    }
    
    public func request(request: NSURLRequest) -> MockRequestType {
        let handler: RequestHandler = { return request }
        return self.request(handler)
    }
    
    public func request(handler: RequestHandler) -> MockRequestType {
        requestHandler = handler
        return self
    }
}

extension Mock {
    public func response(statusCode: Int, body: Body? = nil, header: Header? = nil) -> MockResponseType {
        guard let url = request?.URL, let res = NSHTTPURLResponse(URL: url, statusCode: statusCode, HTTPVersion: nil, headerFields: header) else {
            let error = NSError(domain: errorDomain, code: 0, userInfo: [NSLocalizedFailureReasonErrorKey: "Response is not NSHTTPURLResponse.", NSLocalizedDescriptionKey: "Response is not NSHTTPURLResponse."])
            return response(error)
        }
        
        guard let either = body?.data else {
            return response(res, data: nil)
        }
        
        switch either {
        case .Left(let error):
            return response(error)
        case .Right(let data):
            return response(res, data: data)
        }
    }
    
    public func response(response: NSURLResponse, data: NSData? = nil) -> MockResponseType {
        let handler: ResponseHandler = { _ in return .Success(response, data) }
        return self.response(handler)
    }
    
    public func response(error: NSError) -> MockResponseType {
        let handler: ResponseHandler = { _ in return .Failure(error) }
        return self.response(handler)
    }
    
    public func response(handler: ResponseHandler) -> MockResponseType {
        responseHandler = handler
        return self
    }
}

public protocol MockType: class {
    func down()
    func request(url urlConvertible: URLConvertible) -> MockRequestType
    func request(url urlConvertible: URLConvertible, method: Method) -> MockRequestType
    func request(request: NSURLRequest) -> MockRequestType
}

public protocol MockRequestType: class {
    func response(statusCode: Int, body: Body?, header: Header?) -> MockResponseType
    func response(response: NSURLResponse, data: NSData?) -> MockResponseType
    func response(error: NSError) -> MockResponseType
    func response(handler: Mock.ResponseHandler) -> MockResponseType
}

public protocol MockResponseType: class {
}

public enum Response {
    case Success(NSURLResponse, NSData?)
    case Failure(NSError)
}

public enum Method: String {
    case GET
    case POST
    case PUT
    case DELETE
}
