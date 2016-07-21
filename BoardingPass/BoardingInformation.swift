//
//  BoardingInformation.swift
//  BoardingPass
//
//  Created by Michael Skiba on 7/20/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit

public protocol BoardingInformation {

    var nextViewController: UIViewController? { get }
    var previousViewController: UIViewController? { get }
    var allowGestures: Bool { get }

}

public typealias AnimationFactory = (container: UIViewController?, animated: Bool) -> (() -> ())
public typealias ContextualAnimation = (context: UIViewControllerTransitionCoordinatorContext) -> ()

public extension UIViewController {
    public func perform(animation: AnimationFactory? = nil,
                        completion: AnimationFactory? = nil,
                        cancelation: ContextualAnimation? = nil) {
        let animationInContext: ContextualAnimation = { (context: UIViewControllerTransitionCoordinatorContext) in
            animation?(container: self.parentViewController, animated: context.isAnimated())()
        }
        let completionInContext = { (context: UIViewControllerTransitionCoordinatorContext) in
            if context.isCancelled() {
                cancelation?(context: context)
            }
            else {
                completion?(container: self.parentViewController, animated: context.isAnimated())()
            }
        }
        if let coordinator = transitionCoordinator() {
            coordinator.animateAlongsideTransitionInView(parentViewController?.view, animation: animationInContext, completion: completionInContext)
        }
        else {
            animation?(container: self.parentViewController, animated: false)()
            completion?(container: self.parentViewController, animated: false)()
        }
    }
}

public extension BoardingInformation {

    var nextViewController: UIViewController? {
        return nil
    }
    var previousViewController: UIViewController? {
        guard let viewController = self as? UIViewController else {
            return nil
        }
        return viewController.navigationController?.previousViewController
    }

    var allowGestures: Bool {
        return true
    }

}

private  extension UINavigationController {

    var previousViewController: UIViewController? {
        guard self.viewControllers.count >= 2 else {
            return nil
        }
        let secondToLastIndex = viewControllers.endIndex.predecessor().predecessor()
        return viewControllers[secondToLastIndex]
    }

}
