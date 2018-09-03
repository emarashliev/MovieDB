//
//  Webservice.swift
//  MovieDB
//
//  Created by Emil Marashliev on 29.08.18.
//  Copyright © 2018 Emil Marashliev. All rights reserved.
//

import Foundation
import UAObfuscatedString
import SwiftyJSON
import RxSwift
import Disk

protocol URLConstructible {
    
    static func constructURL(baseUrl: URLComponents, construct: (_ constructedUrl: URLComponents) -> URL?) -> URL?
}

final class Webservice {

    private lazy var baseUrl: URLComponents = {
        var url = URLComponents(string: "https://api.themoviedb.org/3/")!
        url.queryItems = [
            URLQueryItem(name: "".a.p.i.underscore.k.e.y,
                         value: ""._4._9._0._9._1.a._3._8._7.a.e.c._5._7.d._4._5.f._6._1.d.f._9.e.d._3._0._8._7.e._1._5)
        ]
        return url
    }()

    func loadPopular(page: UInt = 1, completion: @escaping (_ popular: Popular) -> Void) {
        if page == 1, let popular = loadPopularMoviesFromCache(popular: Popular()) {
            completion(popular)
            return
        }

        let url = Popular.constructURL(baseUrl: self.baseUrl) {
            var url = $0
            let params = [
                URLQueryItem(name: "sort_by", value: "popularity.desc"),
                URLQueryItem(name: "page", value: "\(page)")
            ]
            url.queryItems?.append(contentsOf: params)
            return url.url!
        }
        let resource = Resource<Popular>(url: url!)
        URLSession.shared.load(resource, completion: { result in
            switch result {
            case .success(let popular, let json):
                self.loadPopularMovies(popular: popular, json: json)
                completion(popular)
            case .error(let error):
                print(error)
            }
        })
    }

    private func loadPopularMovies(popular: Popular, json: JSON) {
        let ids = json.dictionaryValue["results"]!.arrayValue.map { $0.dictionaryValue["id"]!.stringValue }
        for id in ids {
            let url = Movie.constructURL(baseUrl: self.baseUrl) {
                var url = $0
                url.path.append(contentsOf: id)
                return url.url
            }
            let resource = Resource<Movie>(url: url!)
            URLSession.shared.load(resource, completion: { result in
                switch result {
                case .success(let movie, _):
                    var movies = popular.movies.value
                    movies.append(movie)
                    popular.movies.accept(movies)
                    //if is first page and it's loaded
                    if popular.page == 1, popular.movies.value.count == ids.count {
                        try? Disk.save(movies, to: .caches, as: "movies.json")
                    }
                case .error(let error):
                    print(error)
                }
            })
        }
    }

    private func loadPopularMoviesFromCache(popular: Popular) -> Popular? {
        if let movies = try? Disk.retrieve("movies.json", from: .caches, as: [Movie].self) {
            popular.movies.accept(movies)
            return popular
        }
        return nil
    }
}
