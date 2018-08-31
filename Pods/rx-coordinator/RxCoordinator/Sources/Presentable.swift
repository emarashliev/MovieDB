//
//  Presentable.swift
//  RxCoordinator
//
//  Created by Joan Disho on 03.05.18.
//  Copyright © 2018 Stefan Kofler. All rights reserved.
//

import Foundation
import UIKit

public protocol Presentable {
    var viewController: UIViewController! { get }

    func presented(from presentable: Presentable?)
}

extension UIViewController: Presentable {
    public func presented(from presentingVC: Presentable?) {}
}
