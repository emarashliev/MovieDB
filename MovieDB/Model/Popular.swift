//
//  Popular.swift
//  MovieDB
//
//  Created by Emil Marashliev on 30.08.18.
//  Copyright © 2018 Emil Marashliev. All rights reserved.
//

import Foundation
import SwiftyJSON

final class Popular {

    var page: UInt
    var movies = [Movie]()

    init(page: UInt) {
        self.page = page
    }
}


extension Popular: Decodable {

    private enum CodingKeys: String, CodingKey {
        case page
    }

    convenience init(from decoder: Decoder) throws {
        self.init(page: 1)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        page = try values.decode(UInt.self, forKey: .page)

    }
}

extension Popular: JSONDataLoadable {

    static func load(from data: Data) -> Popular {
        let jsonDecoder = JSONDecoder()
        let popular = try! jsonDecoder.decode(Popular.self, from: data)
        if let json = try? JSON(data: data) {
            for m in json["results"].arrayValue {
                let movie = Movie.load(from: try! m.rawData())
                popular.movies.append(movie)
            }
        }
        return popular
    }
}
