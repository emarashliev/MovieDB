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
    private var lastLoadedPage: UInt
    private var pageInProgress = false
    
    private let coordinator: AnyCoordinator<MainRoute>
    private let webservice = Webservice()
    private let disposeBag = DisposeBag()
    
    init(coodinator: AnyCoordinator<MainRoute>) {
        self.coordinator = coodinator
        lastLoadedPage = 0
        fetchNextPage()
    }
    
    func fetchNextPage()  {
        guard !pageInProgress else {
            return
        }
        
        pageInProgress = true
        DispatchQueue.global(qos: .userInitiated).async {
            self.webservice.loadPopular(page: self.lastLoadedPage + 1) { popular in
                popular.moviesPublishSubject.subscribe(onNext: { movie in
                    var movies = self.movies.value
                    movies.append(movie)
                    self.movies.accept(movies)
                }, onError: { error in
                    self.pageInProgress = false
                    print(error)
                }, onCompleted: {
                    self.lastLoadedPage = popular.page
                    self.pageInProgress = false
                })
                    .disposed(by: self.disposeBag)
                
                _ = popular.moviesPublishSubject.retry(3)
            }
        }
    }
}
