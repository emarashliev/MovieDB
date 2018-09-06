//
//  Genre.swift
//  MovieDB
//
//  Created by Emil Marashliev on 6.09.18.
//  Copyright © 2018 Emil Marashliev. All rights reserved.
//

import Foundation

final class Genre: Codable {

    var id: UInt
    var name: String
}

extension Genre: JSONDataLoadable {

    static func load(from data: Data) -> Genre {
        let jsonDecoder = JSONDecoder()
        let genre = try! jsonDecoder.decode(Genre.self, from: data)
        return genre
    }
}
