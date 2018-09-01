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

extension NibIdentifiable where Self: UIView {
    
    static func instantiateFromNib() -> Self {
        guard let view = UINib(nibName: nibIdentifier, bundle: nil).instantiate(withOwner: nil, options: nil).first as? Self else {
            fatalError("Couldn't find nib file for \(String(describing: Self.self))")
        }
        return view
    }
    
}
