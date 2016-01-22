//
//  Mock.swift
//  Mockin
//
//  Created by yukiasai on 2016/01/23.
//  Copyright © 2016年 yukiasai. All rights reserved.
//

import Foundation

public class Mock {
    static var pool = [Mock]()
    
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
}
