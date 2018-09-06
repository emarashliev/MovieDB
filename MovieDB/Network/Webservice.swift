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

    static let imagesBaseUrl = URLComponents(string: "https://image.tmdb.org/t/p/w500/")!

    // MARK: - Private lazys
    private let popularMoviesCacheFolder = "popularMovies"
    private lazy var baseUrl: URLComponents = {
        var url = URLComponents(string: "https://api.themoviedb.org/3/")!
        url.queryItems = [
            URLQueryItem(name: "".a.p.i.underscore.k.e.y,
                         value: ""._4._9._0._9._1.a._3._8._7.a.e.c._5._7.d._4._5.f._6._1.d.f._9.e.d._3._0._8._7.e._1._5)
        ]
        return url
    }()

    // MARK: -

    func loadPopular(page: UInt = 1, completion: @escaping (_ popular: Popular) -> Void) {
        if let movies = loadCachedMovies(for: page) {
            let popular = Popular(page: page)
            completion(popular)
            popular.movies = movies
            for movie in movies {
                popular.moviesPublishSubject.on(.next(movie))
            }
            popular.moviesPublishSubject.on(.completed)
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
                self.loadMovies(popular: popular, json: json)
                completion(popular)
            case .error(let error):
                print(error)

            }
        })
    }

    func search(query: String, completion: @escaping (_ movies: [Movie]) -> Void) {
        var url = baseUrl
        url.path.append(contentsOf: "search/movie")
        url.queryItems?.append(contentsOf: [URLQueryItem(name: "query", value: query)])

        let resource = Resource<[Movie]>(url: url.url!)
        URLSession.shared.load(resource, completion: { result in
            switch result {
            case .success(let movies, _):
                completion(movies)
            case .error(let error):
                print(error)
            }
        })
    }

    func deleteCache()  {
       try? Disk.remove(popularMoviesCacheFolder, from: .caches)
    }

    // MARK: - Private
    
    private func loadMovies(popular: Popular, json: JSON) {
        let ids = json.dictionaryValue["results"]?.arrayValue.map { $0.dictionaryValue["id"]?.uIntValue } ?? []
        for id in ids {
            let url = Movie.constructURL(baseUrl: self.baseUrl) {
                var url = $0
                url.path.append(contentsOf: "\(id!)")
                return url.url
            }
            let resource = Resource<Movie>(url: url!)
            URLSession.shared.load(resource, completion: { result in
                switch result {
                case .success(let movie, _):
                    popular.moviesPublishSubject.on(.next(movie))
                    popular.movies.append(movie)
                    if movie.id == ids.last {
                        try? Disk.save(popular.movies,
                                       to: .caches,
                                       as: "\(self.popularMoviesCacheFolder)/\(popular.page).json")
                        popular.moviesPublishSubject.on(.completed)
                    }
                case .error(let error):
                    popular.moviesPublishSubject.on(.error(error))
                }
            })
        }
    }

    private func loadCachedMovies(for page: UInt) -> [Movie]? {
        return try? Disk.retrieve("\(popularMoviesCacheFolder)/\(page).json", from: .caches, as: [Movie].self)
    }
}
