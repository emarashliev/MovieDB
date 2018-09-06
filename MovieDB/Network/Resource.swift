//
//  Resource.swift
//  MovieDB
//
//  Created by Emil Marashliev on 29.08.18.
//  Copyright © 2018 Emil Marashliev. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol JSONDataLoadable {

    static func load(from data: Data) -> Self
}

struct APIError: Error {
    var localizedDescription: String
}

struct Resource<T> {

    let url: URL
    let parseResult: (Data) -> Result<T>

    var request: URLRequest {
        let r = URLRequest(url: url)
        return r
    }
}

extension Resource where T: JSONDataLoadable {

    init(url: URL) {
        self.url = url
        self.parseResult = { data in
            return .success(T.load(from: data))
        }
    }
}

extension URLSession {
    
    @discardableResult
    func load<T>(_ resource: Resource<T>, completion: @escaping (Result<T>) -> ()) -> URLSessionDataTask {
        let task = dataTask(with: resource.request) { (data, response, error) in
            if let r = response as? HTTPURLResponse, let d = data, 200 ..< 305 ~= r.statusCode {
                completion(resource.parseResult(d))
            } else if let e = error {
                completion(.error(e))
            } else if let d = data {
                let j = JSON(d)
                let e = APIError(localizedDescription: j["status_message"].stringValue)
                completion(.error(e))

            }
        }
        task.resume()
        return task
    }
}

extension Array: JSONDataLoadable where Element: JSONDataLoadable {
    static func load(from data: Data) -> Array<Element> {
        let json = JSON(data)
        var elements = [Element]()

        var key: String? = nil
        if Element.self == Movie.self {
            key = "results"
        } else if Element.self == Genre.self {
            key = "genres"
        }

        for e in json[key!].arrayValue {
            if let d = try? e.rawData() {
                let element = Element.load(from: d)
                elements.append(element)
            }
        }
        return elements
    }
}


