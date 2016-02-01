//
//  Body.swift
//  Kagee
//
//  Created by yukiasai on 1/27/16.
//  Copyright © 2016 yukiasai. All rights reserved.
//

import Foundation

public protocol Body {
    var data: Either<NSError, NSData> { get }
}

extension NSData: Body {
    public var data: Either<NSError, NSData> {
        return .Right(self)
    }
}

extension String: Body {
    public var data: Either<NSError, NSData> {
        return Text(self).data
    }
}

public class JSON: Body {
    let object: AnyObject
    public init(_ object: AnyObject) {
        self.object = object
    }
    
    public var data: Either<NSError, NSData> {
        do {
            let data = try NSJSONSerialization.dataWithJSONObject(object, options: .PrettyPrinted)
            return .Right(data)
        } catch {
            return .Left(error as NSError)
        }
    }
}

public class File: Body {
    let url: NSURL
    public init(_ url: NSURL) {
        self.url = url
    }
    
    public convenience init(string: String) {
        guard let url = NSURL(string: string) else {
            fatalError()
        }
        self.init(url)
    }
    
    public var data: Either<NSError, NSData> {
        do {
            let data = try NSData(contentsOfURL: url, options: .DataReadingUncached)
            return .Right(data)
        } catch {
            return .Left(error as NSError)
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
    
    public var data: Either<NSError, NSData> {
        if let data = string.dataUsingEncoding(encoding) {
            return .Right(data)
        } else {
            let message = "Failed to encode the string."
            let error = NSError(domain: errorDomain, code: 0, userInfo: [NSLocalizedFailureReasonErrorKey: message, NSLocalizedDescriptionKey: message])
            return .Left(error as NSError)
        }
    }
}
