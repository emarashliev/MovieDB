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

final class Webservice {

    static let imagesBaseUrl = URLComponents(string: "https://image.tmdb.org/t/p/w500/")!

    // MARK: - Private 
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

    func loadPopular(page: UInt = 1, completion: @escaping (_ popular: Popular, _ genres: [Genre]) -> Void) {
        if let movies = loadCachedMovies(for: page) {
            let popular = Popular(page: page)
            popular.movies = movies
            self.loadGenres(completion: { genres in
                completion(popular, genres)
            })
            return
        }

        var url = self.baseUrl
        let params = [
            URLQueryItem(name: "sort_by", value: "popularity.desc"),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        url.queryItems?.append(contentsOf: params)
        url.path.append(contentsOf: "movie/popular")
        let resource = Resource<Popular>(url: url.url!)
        
        URLSession.shared.load(resource, completion: { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let popular):
                strongSelf.loadGenres(completion: { genres in
                    completion(popular, genres)
                })
                try? Disk.save(popular.movies,
                               to: .caches,
                               as: "\(strongSelf.popularMoviesCacheFolder)/\(popular.page).json")
            case .error(let error):
                print(error)

            }
        })
    }

    func loadMovieDetails(movie: Movie, completion: @escaping (_ detailedMovie: Movie) -> Void) {
        var url = self.baseUrl
        url.path.append(contentsOf: "movie/\(movie.id!)")
        let resource = Resource<Movie>(url: url.url!)

        URLSession.shared.load(resource, completion: { result in
            switch result {
            case .success(let detailedMovie):
                completion(detailedMovie)
            case .error(let error):
                print(error)
            }
        })
    }

    func search(query: String, completion: @escaping (_ movies: [Movie], _ genres: [Genre]) -> Void) {
        var url = baseUrl
        url.path.append(contentsOf: "search/movie")
        url.queryItems?.append(contentsOf: [URLQueryItem(name: "query", value: query)])
        let resource = Resource<[Movie]>(url: url.url!)

        URLSession.shared.load(resource, completion: { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let movies):
                strongSelf.loadGenres(completion: { genres in
                    completion(movies, genres)
                })
            case .error(let error):
                print(error)
            }
        })
    }


    func deleteCache()  {
        try? Disk.remove(popularMoviesCacheFolder, from: .caches)
    }

    // MARK: - Private

    private func loadGenres(completion: @escaping (_ genres: [Genre]) -> Void) {
        var url = baseUrl
        url.path.append(contentsOf: "genre/movie/list")
        let resource = Resource<[Genre]>(url: url.url!)

        URLSession.shared.load(resource, completion: { result in
            switch result {
            case .success(let genres):
                completion(genres)
            case .error(let error):
                print(error)
            }
        })
    }

    private func loadCachedMovies(for page: UInt) -> [Movie]? {
        return try? Disk.retrieve("\(popularMoviesCacheFolder)/\(page).json", from: .caches, as: [Movie].self)
    }
}
