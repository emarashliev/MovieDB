//
//  HomeViewModel.swift
//  MovieDB
//
//  Created by Emil Marashliev on 31.08.18.
//  Copyright © 2018 Emil Marashliev. All rights reserved.
//

import Foundation
import RxSwift
import RxCoordinator

class HomeViewModel {

    private let coordinator: AnyCoordinator<MainRoute>
    private let webservice = Webservice()

    init(coodinator: AnyCoordinator<MainRoute>) {
        self.coordinator = coodinator
    }
}
