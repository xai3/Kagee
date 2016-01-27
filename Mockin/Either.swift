//
//  Either.swift
//  Mockin
//
//  Created by yukiasai on 1/27/16.
//  Copyright © 2016 yukiasai. All rights reserved.
//

enum Either<L, R> {
    case Left(L)
    case Right(R)
}
