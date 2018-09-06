//
//  MainRoute.swift
//  MovieDB
//
//  Created by Emil Marashliev on 31.08.18.
//  Copyright © 2018 Emil Marashliev. All rights reserved.
//

import Foundation
import RxCoordinator

enum MainRoute: Route {
    case home
    case details(MovieDataTransformHelper)

    func prepareTransition(coordinator: AnyCoordinator<MainRoute>) -> NavigationTransition {
        switch self {
        case .home:
            var viewController = HomeViewController.instantiateFromNib()
            viewController.title = "Popular Movies"
            let viewModel = HomeViewModel(coodinator: coordinator)
            viewController.bind(to: viewModel)
            return .push(viewController)
        case .details(let movie):
            var viewController = DetailsViewController.instantiateFromNib()
            let viewModel = DetailsViewModel(coodinator: coordinator, movie: movie)
            viewController.bind(to: viewModel)
            return .push(viewController)
        }


    }
}
