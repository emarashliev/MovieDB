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
    private let disposeBag = DisposeBag()

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
            self.webservice.loadPopular(page: self.lastLoadedPage + 1) { popular in
                popular.moviesPublishSubject.subscribe(onNext: { movie in
                    var movies = self.movies.value
                    movies.append(MovieDataTransformHelper(movie: movie))
                    self.movies.accept(movies)
                }, onError: { error in
                    self.inProgress = false
                    print(error)
                }, onCompleted: {
                    self.lastLoadedPage = popular.page
                    self.inProgress = false
                })
                    .disposed(by: self.disposeBag)
                
                _ = popular.moviesPublishSubject.retry(3)
            }
        }
    }

    func search(forMovies query: String)  {
        inProgress = true
        webservice.search(query: query) { m in
            let movies = m.sorted(by: {
                guard let popularity0 = $0.popularity, let popularity1 = $1.popularity else { return false }
                return popularity0 > popularity1
            })
            self.movies.accept(movies.map { MovieDataTransformHelper(movie: $0) })
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
