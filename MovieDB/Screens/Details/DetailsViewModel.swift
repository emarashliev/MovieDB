//
//  File.swift
//  MovieDB
//
//  Created by Emil Marashliev on 5.09.18.
//  Copyright © 2018 Emil Marashliev. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxCoordinator

final class DetailsViewModel {

    let movie: BehaviorRelay<MovieDataTransformHelper>

    // MARK: - Private
    
    private let webservice = Webservice()
    private let coordinator: AnyCoordinator<MainRoute>

    // MARK: - Init
    
    init(coodinator: AnyCoordinator<MainRoute>, movie: MovieDataTransformHelper) {
        self.coordinator = coodinator
        self.movie = BehaviorRelay(value: movie)
    }

    // MARK: - Actions
    
    func fetchDetails() {
        webservice.loadMovieDetails(movie: movie.value.movie) { [weak self] detailedMovie in
            guard let strongSelf = self else {
                return
            }
            strongSelf.movie.accept(MovieDataTransformHelper(movie: detailedMovie,
                                                             genres: strongSelf.movie.value.genres))
        }
    }
}
