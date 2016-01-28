//
//  Network.swift
//  Mockin
//
//  Created by yukiasai on 2016/01/28.
//  Copyright © 2016年 yukiasai. All rights reserved.
//

import Foundation

public class Network {
    public enum Speed {
        case Prompt
        case Wifi
        case Mobile4G
        case Mobile3G
        case Edge
        
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
}
