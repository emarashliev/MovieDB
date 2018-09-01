//
//  BindableType.swift
//  MovieDB
//
//  Created by Emil Marashliev on 31.08.18.
//  Copyright © 2018 Emil Marashliev. All rights reserved.
//

import UIKit

protocol BindableType {
    
    associatedtype ViewModelType
    
    var viewModel: ViewModelType! { get set }
    
    func bindViewModel()
}

extension BindableType where Self: UIViewController {
    
    mutating func bind(to model: Self.ViewModelType) {
        viewModel = model
        loadViewIfNeeded()
        bindViewModel()
    }
    
}
