//
//  NibIdentifiable.swift
//  MovieDB
//
//  Created by Emil Marashliev on 31.08.18.
//  Copyright © 2018 Emil Marashliev. All rights reserved.
//

import UIKit

protocol NibIdentifiable {
    
    static var nibIdentifier: String { get }
}

extension NibIdentifiable {
    
    static var nib: UINib {
        return UINib(nibName: nibIdentifier, bundle: nil)
    }
}

extension UIView: NibIdentifiable {
    
    static var nibIdentifier: String {
        return String(describing: self)
    }
}

extension UIViewController: NibIdentifiable {
    
    static var nibIdentifier: String {
        return String(describing: self)
    }
}

extension NibIdentifiable where Self: UIViewController {
    
    static func instantiateFromNib() -> Self {
        return Self(nibName: nibIdentifier, bundle: nil)
    }
}

extension UICollectionView {

    func registerCell<T: UICollectionViewCell>(type: T.Type) {
        register(type.nib, forCellWithReuseIdentifier: String(describing: T.self))
    }
}
