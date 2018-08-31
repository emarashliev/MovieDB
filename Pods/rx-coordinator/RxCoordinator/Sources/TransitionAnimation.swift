//
//  TransitionAnimation.swift
//  RxCoordinator
//
//  Created by Stefan Kofler on 03.05.18.
//  Copyright © 2018 Stefan Kofler. All rights reserved.
//

import Foundation
import UIKit

public protocol TranistionAnimation: UIViewControllerAnimatedTransitioning {
    var duration: TimeInterval { get }
    var performAnimation: (_ transitionContext: UIViewControllerContextTransitioning) -> Void { get }
}

