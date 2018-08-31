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
    
    func loadPopular(page: UInt8 = 1) {
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
            case .success(let popular):
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10, execute: {
                    print(popular.movies)
                })
                print(popular.movies)
            case .error(let error):
                print(error)
            }
        })
    }
}
