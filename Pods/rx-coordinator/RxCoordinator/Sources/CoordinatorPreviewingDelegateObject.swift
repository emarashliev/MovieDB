//
//  CoordinatorPreviewingDelegateObject.swift
//  rx-coordinator
//
//  Created by Stefan Kofler on 19.07.18.
//

import UIKit

class CoordinatorPreviewingDelegateObject<T: TransitionType, R: Route>: NSObject, UIViewControllerPreviewingDelegate {

    let transition: () -> Transition<T>
    let coordinator: AnyCoordinator<R>

    weak var viewController: UIViewController?

    init(transition: @escaping () -> Transition<T>, coordinator: AnyCoordinator<R>) {
        self.transition = transition
        self.coordinator = coordinator
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let viewController = viewController {
            return viewController
        }

        let presentable = transition().presentable
        presentable?.presented(from: nil)
        viewController = presentable?.viewController
        return viewController
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        _ = coordinator.performTransition(transition(), with: TransitionOptions.defaultOptions)
    }

}
