//
//  Body.swift
//  Mockin
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
