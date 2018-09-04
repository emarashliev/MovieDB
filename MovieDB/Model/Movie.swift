//
//  Movie.swift
//  MovieDB
//
//  Created by Emil Marashliev on 29.08.18.
//  Copyright © 2018 Emil Marashliev. All rights reserved.
//

import Foundation

final class Movie: Encodable {
    
    struct Genre: Codable {
        
        var id: UInt
        var name: String
    }

    var id: UInt?
    var title: String?
    var popularity: Double?
    var posterPath: String?
    var releaseDate: String?
    var genres: [Genre] = []
    var overview: String?
    var runtime: UInt?
    var revenue: UInt?
    var originalLanguage: String?
    var homepage: String?
}

extension Movie: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case originalLanguage = "original_language"

        case id
        case title
        case popularity
        case overview
        case genres
        case revenue
        case runtime
        case homepage
    }
    
    convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decode(UInt.self, forKey: .id)
        title = try? values.decode(String.self, forKey: .title)
        popularity = try? values.decode(Double.self, forKey: .popularity)
        posterPath = try? values.decode(String.self, forKey: .posterPath)
        releaseDate = try? values.decode(String.self, forKey: .releaseDate)
        overview = try? values.decode(String.self, forKey: .releaseDate)
        runtime = try? values.decode(UInt.self, forKey: .runtime)
        revenue = try? values.decode(UInt.self, forKey: .revenue)
        originalLanguage = try? values.decode(String.self, forKey: .originalLanguage)
        homepage = try? values.decode(String.self, forKey: .homepage)
        genres = (try? values.decode([Genre].self, forKey: .genres)) ?? []
        
    }
}

extension Movie: JSONDataLoadable {
    
    static func load(from data: Data) -> Movie {
        let jsonDecoder = JSONDecoder()
        let movie = try! jsonDecoder.decode(Movie.self, from: data)
        return movie
    }
}

extension Movie: URLConstructible {
    
    static func constructURL(baseUrl: URLComponents, construct: (_ constructedUrl: URLComponents) -> URL?) -> URL? {
        var url = baseUrl
        url.path.append(contentsOf: "movie/")
        return construct(url)
    }
    
    
}
