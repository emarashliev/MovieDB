//
//  File.swift
//  MovieDB
//
//  Created by Emil Marashliev on 5.09.18.
//  Copyright © 2018 Emil Marashliev. All rights reserved.
//

import Foundation
import RxCoordinator

final class DetailsViewModel {

    private let coordinator: AnyCoordinator<MainRoute>
    let movie: MovieDataTransformHelper

    init(coodinator: AnyCoordinator<MainRoute>, movie: MovieDataTransformHelper) {
        self.coordinator = coodinator
        self.movie = movie
    }
    
}
