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

    func prepareTransition(coordinator: AnyCoordinator<MainRoute>) -> NavigationTransition {
        switch self {
        case .home:
            var viewController = HomeViewController.instantiateFromNib()
            let viewModel = HomeViewModel(coodinator: coordinator)
            viewController.bind(to: viewModel)
            return .push(viewController)
        }
    }
}
