//
//  Result.swift
//  MovieDB
//
//  Created by Emil Marashliev on 29.08.18.
//  Copyright © 2018 Emil Marashliev. All rights reserved.
//

import Foundation

enum Result<T> {
    case error(Error)
    case success(T)

    init(_ value: T?, error: @autoclosure () -> Error) {
        if let x = value {
            self = .success(x)
        } else {
            self = .error(error())
        }
    }
}
