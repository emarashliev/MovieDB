//
//  MovieDataTransformHelper.swift
//  MovieDB
//
//  Created by Emil Marashliev on 4.09.18.
//  Copyright © 2018 Emil Marashliev. All rights reserved.
//

import Foundation

final class MovieDataTransformHelper {

    let movie: Movie


    var title: String {
        return movie.title ?? "N/A"
    }

    var popularity: String {
        return String(format: "%.3f", movie.popularity!)
    }

    var posterUrl: URL? {
        var url = Webservice.imagesBaseUrl
        if let path = movie.posterPath {
            url.path.append(contentsOf: path)
            return url.url!
        }
        return nil
    }

    var releaseYear: String {
        if let dateString = movie.releaseDate,
            let date = MovieDataTransformHelper.parseFormatter.date(from: dateString) {
            return MovieDataTransformHelper.yearFormatter.string(from: date)
        }
        return "N/A"
    }

    var genres: String {
        return movie.genres.compactMap { $0.name }.joined(separator: ", ")
    }

    var overview: String {
        return movie.overview ?? "N/A"
    }

    var runtime: String {
        if let runtime = movie.runtime {
            return String(runtime) + " min."
        }
        return "N/A"
    }

    var revenue: String {
        if let revenue = movie.revenue,
            let r = MovieDataTransformHelper.currencyFormatter.string(from: revenue as NSNumber) {
            return r
        }
        return "N/A"
    }

    var language: String {
        return movie.originalLanguage ?? "N/A"
    }

    var homepageUrl: URL? {
        if let text = movie.homepage {
            return URL(string: text)
        } else {
            return nil
        }
    }

    var homepage: NSAttributedString {
        var attrString: NSMutableAttributedString? = nil
        if let url = homepageUrl {
            attrString = NSMutableAttributedString(string: url.absoluteString)
            attrString!.addAttributes([.link : url], range:  NSRange(location: 0, length: url.absoluteString.count))
        } else {
            attrString = NSMutableAttributedString(string: "N/A")
        }
        return attrString!
    }

    private static var yearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY"
        return formatter
    }

    private static var parseFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD"
        return formatter
    }

    private static var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .currency
        return formatter
    }

    init(movie: Movie) {
        self.movie = movie
    }
}
