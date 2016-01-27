//
//  Body.swift
//  Mockin
//
//  Created by yukiasai on 1/27/16.
//  Copyright © 2016 yukiasai. All rights reserved.
//

import Foundation

public enum Body {
    case JSON(AnyObject)
    case Data(NSData)
    case File(NSURL)
    
    var data: Either<NSError, NSData> {
        switch self {
        case .JSON(let object):
            do {
                let data = try NSJSONSerialization.dataWithJSONObject(object, options: .PrettyPrinted)
                return .Right(data)
            } catch {
                return .Left(error as NSError)
            }
        case .Data(let data):
            return .Right(data)
        case .File(let url):
            do {
                let data = try NSData(contentsOfURL: url, options: .DataReadingUncached)
                return .Right(data)
            } catch {
                return .Left(error as NSError)
            }
        }
    }
}
