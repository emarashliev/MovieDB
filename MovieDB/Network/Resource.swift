//
//  Resource.swift
//  MovieDB
//
//  Created by Emil Marashliev on 29.08.18.
//  Copyright © 2018 Emil Marashliev. All rights reserved.
//

import Foundation

protocol JSONDataLoadable {
    static func load(from jsonData: Data) -> Self
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
        let task = dataTask(with: resource.request) { (data, _, error) in
            if let e = error {
                completion(.error(e))
            } else if let d = data {
                completion(resource.parseResult(d))
            }
        }
        task.resume()
        return task
    }
}
