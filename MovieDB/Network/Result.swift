//
//  Result.swift
//  MovieDB
//
//  Created by Emil Marashliev on 29.08.18.
//  Copyright © 2018 Emil Marashliev. All rights reserved.
//

import Foundation
import SwiftyJSON

enum Result<T> {
    
    case error(Error)
    case success(T, JSON)

    init(_ value: T?, json: JSON?, error: @autoclosure () -> Error) {
        if let v = value, let j = json {
            self = .success(v, j)
        } else {
            self = .error(error())
        }
    }
}
