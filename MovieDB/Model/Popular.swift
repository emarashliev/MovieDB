//
//  Popular.swift
//  MovieDB
//
//  Created by Emil Marashliev on 30.08.18.
//  Copyright © 2018 Emil Marashliev. All rights reserved.
//

import Foundation
import RxCocoa

final class Popular {

    var page: UInt!
    var movies = BehaviorRelay<[Movie]>(value: [])
}


extension Popular: Decodable {

    private enum CodingKeys: String, CodingKey {
        case page
    }

    convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        page = try values.decode(UInt.self, forKey: .page)

    }
}

extension Popular: JSONDataLoadable {

    static func load(from data: Data) -> Popular {
        let jsonDecoder = JSONDecoder()
        let popular = try! jsonDecoder.decode(Popular.self, from: data)
        return popular
    }
}

extension Popular: URLConstructible {
    
    static func constructURL(baseUrl: URLComponents, construct: (URLComponents) -> URL?) -> URL? {
        var url = baseUrl
        url.path.append(contentsOf: "movie/popular")
        return construct(url)
    }
}
