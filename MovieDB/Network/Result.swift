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
    case success(T)

    init(_ value: T?, error: @autoclosure () -> Error) {
        if let v = value {
            self = .success(v)
        } else {
            self = .error(error())
        }
    }
}
