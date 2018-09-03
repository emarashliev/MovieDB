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

class HomeViewModel {


    var movies = BehaviorRelay<[Movie]>(value: [])
    private let coordinator: AnyCoordinator<MainRoute>
    private let webservice = Webservice()
    private let disposeBag = DisposeBag()

    init(coodinator: AnyCoordinator<MainRoute>) {
        self.coordinator = coodinator
        webservice.loadPopular { popular in
            popular.movies.bind(to: self.movies)
                .disposed(by: self.disposeBag)

        }
    }
}
