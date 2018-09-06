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
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.webservice.loadPopular(page: strongSelf.lastLoadedPage + 1) { popular, genres in
                let movies = popular.movies.map { MovieDataTransformHelper(movie: $0, genres: genres) }
                strongSelf.movies.accept(strongSelf.movies.value + movies)
                strongSelf.lastLoadedPage = popular.page
                strongSelf.inProgress = false
            }
        }
    }
    
    func search(forMovies query: String)  {
        inProgress = true
        webservice.search(query: query) { [weak self] m, genres in
            guard let strongSelf = self else {
                return
            }

            let movies = m.sorted(by: {
                guard let popularity0 = $0.popularity, let popularity1 = $1.popularity else { return false }
                return popularity0 > popularity1
            })
            strongSelf.movies.accept(movies.map { MovieDataTransformHelper(movie: $0, genres: genres) })
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
