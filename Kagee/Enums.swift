//
//  Network.swift
//  Kagee
//
//  Created by yukiasai on 2016/01/28.
//  Copyright © 2016年 yukiasai. All rights reserved.
//

import Foundation

public enum Response {
    case Success(NSURLResponse, NSData?)
    case Failure(NSError)
}

public enum ResponseData {
    case Data(NSData)
    case Error(NSError)
}

public enum Method: String {
    case GET
    case POST
    case PUT
    case DELETE
}

public enum Speed {
    case Prompt
    case Wifi
    case Mobile4G
    case Mobile3G
    case Edge
    case Custom(bps: Double)
    
    var bps: Double? {
        switch self {
        case .Prompt:
            return nil
        case .Wifi:
            return 45_000_000
        case .Mobile4G:
            return 10_000_000
        case .Mobile3G:
            return 1_000_000
        case .Edge:
            return 200_000
        case .Custom(let bps):
            return bps
        }
    }
    
    func sec(bytes: UInt32) -> UInt32? {
        guard let bps = self.bps else {
            return nil
        }
        return UInt32(Double(bytes * 8) / bps)
    }
    
    func usec(bytes: UInt32) -> UInt32? {
        guard let sec = sec(bytes) else {
            return nil
        }
        return sec * 1_000_000
    }
}
