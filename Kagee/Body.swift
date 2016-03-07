//
//  Body.swift
//  Kagee
//
//  Created by yukiasai on 1/27/16.
//  Copyright © 2016 yukiasai. All rights reserved.
//

import Foundation

public protocol Body {
    var data: ResponseData { get }
}

extension NSData: Body {
    public var data: ResponseData {
        return .Data(self)
    }
}

extension String: Body {
    public var data: ResponseData {
        return Text(self).data
    }
}

public class JSON: Body {
    let object: AnyObject
    public init(_ object: AnyObject) {
        self.object = object
    }
    
    public var data: ResponseData {
        do {
            let data = try NSJSONSerialization.dataWithJSONObject(object, options: .PrettyPrinted)
            return .Data(data)
        } catch {
            return .Error(error as NSError)
        }
    }
}

public class File: Body {
    let url: NSURL
    
    public init(url urlConvertible: URLConvertible) {
        self.url = urlConvertible.URL
    }
    
    public var data: ResponseData {
        do {
            let data = try NSData(contentsOfURL: url, options: .DataReadingUncached)
            return .Data(data)
        } catch {
            return .Error(error as NSError)
        }
    }
}

public class Text: Body {
    let string: String
    let encoding: NSStringEncoding
    public init(_ string: String, encoding: NSStringEncoding = NSUTF8StringEncoding) {
        self.string = string
        self.encoding = encoding
    }
    
    public var data: ResponseData {
        if let data = string.dataUsingEncoding(encoding) {
            return .Data(data)
        } else {
            let message = "Failed to encode the string."
            let error = NSError(domain: errorDomain, code: 0, userInfo: [NSLocalizedFailureReasonErrorKey: message, NSLocalizedDescriptionKey: message])
            return .Error(error as NSError)
        }
    }
}
