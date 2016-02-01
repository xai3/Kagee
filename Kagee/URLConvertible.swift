//
//  URLConvertible.swift
//  Kagee
//
//  Created by yukiasai on 1/27/16.
//  Copyright © 2016 yukiasai. All rights reserved.
//

import Foundation

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

extension NSURL: URLConvertible {
    public var URL: NSURL {
        return self
    }
}
