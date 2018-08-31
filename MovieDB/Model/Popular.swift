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

    var page: UInt8 = 1
    var movies: [Movie] = []

    private static var baseUrl: URLComponents?

    convenience init(page: UInt8, movies: [Movie]) {
        self.init()
        self.page = page
        self.movies = movies
    }
}

extension Popular: JSONDataLoadable {
    static func load(from jsonData: Data) -> Popular {
        let json = JSON(jsonData)
        let popular = Popular(page: json.dictionaryValue["page"]!.uInt8Value, movies: [Movie]())
        let ids = json.dictionaryValue["results"]!.arrayValue.map { $0.dictionaryValue["id"]!.stringValue }
        for id in ids {
            let url = Movie.constructURL(baseUrl: self.baseUrl!) {
                var url = $0
                url.path.append(contentsOf: id)
                return url.url
            }
            let resource = Resource<Movie>(url: url!)
            URLSession.shared.load(resource, completion: { result in
                switch result {
                case .success(let movie):
                    popular.movies.append(movie)
                case .error(let error):
                    print(error)
                }
            })
        }
        return popular
    }
}

extension Popular: URLConstructible {
    static func constructURL(baseUrl: URLComponents, construct: (URLComponents) -> URL?) -> URL? {
        self.baseUrl = baseUrl
        var url = baseUrl
        url.path.append(contentsOf: "movie/popular")
        return construct(url)
    }
}
