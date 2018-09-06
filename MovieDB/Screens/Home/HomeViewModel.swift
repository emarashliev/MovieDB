//
//  HomeViewModel.swift
//  MovieDB
//
//  Created by Emil Marashliev on 31.08.18.
//  Copyright © 2018 Emil Marashliev. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxCoordinator

final class HomeViewModel {
    
    var movies = BehaviorRelay<[MovieDataTransformHelper]>(value: [])
    
    // MARK: - Private
    
    private var lastLoadedPage: UInt
    private var inProgress = false
    private let coordinator: AnyCoordinator<MainRoute>
    private let webservice = Webservice()
    
    // MARK: - Init
    
    init(coodinator: AnyCoordinator<MainRoute>) {
        self.coordinator = coodinator
        lastLoadedPage = 0
        fetchNextPage()
    }
    
    // MARK: - Actions
    
    func fetchNextPage()  {
        guard !inProgress else {
            return
        }

        inProgress = true
        DispatchQueue.global(qos: .userInteractive).async {
            self.webservice.loadPopular(page: self.lastLoadedPage + 1) { popular, genres in
                let movies = popular.movies.map { MovieDataTransformHelper(movie: $0, genres: genres) }
                self.movies.accept(self.movies.value + movies)
                self.lastLoadedPage = popular.page
                self.inProgress = false
            }
        }
    }
    
    func search(forMovies query: String)  {
        inProgress = true
        webservice.search(query: query) { m, genres in
            let movies = m.sorted(by: {
                guard let popularity0 = $0.popularity, let popularity1 = $1.popularity else { return false }
                return popularity0 > popularity1
            })
            self.movies.accept(movies.map { MovieDataTransformHelper(movie: $0, genres: genres) })
        }
    }
    
    func showDetails(for item: Int) {
        let movie = movies.value[item]
        coordinator.transition(to: .details(movie))
    }
    
    func reset() {
        self.movies.accept([])
        lastLoadedPage = 0
        inProgress = false
        fetchNextPage()
    }
    
    func refresh() {
        webservice.deleteCache()
        reset()
    }
}
