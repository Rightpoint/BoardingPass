//
//  BoardingInformation.swift
//  BoardingPass
//
//  Created by Michael Skiba on 7/20/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit

public protocol BoardingInformation {

    /// Used to determine the next view controller to push in the stack, a nil value means there is no next view,
    /// so no swipe left for next gesture will be allowed
    var nextViewController: UIViewController? { get }
    /// Used to determine the previous view controller to pop to, the default value of the previous view controller
    /// in the navigation stack. A nil value will explicitly disable the swipe right for previous view gesture.
    var previousViewController: UIViewController? { get }

}

public typealias AnimationFactory = (container: UIViewController?, animated: Bool) -> (() -> ())
public typealias ContextualAnimation = (context: UIViewControllerTransitionCoordinatorContext) -> ()

public extension UIViewController {

    /**
     A function for handling an animation that may or may not be performed alongside an animation context

     - parameter animation: A closture that takes a view controller and an animated flag and returns an animation block
                            to perform perform, either alongside a context if one exists, with a fallback of applying
                            it to the view
     - parameter completion: A closure that takes a view controller and an animated flag, and returns an animation block
                             to perform alongside a context, with a fallback of applying it to the view
     - parameter cancelation: A cancellation action to handle restoration of any state that isn't properly rolled back
                              if the animation block is cancelled
     */
    public func perform(animation: AnimationFactory? = nil,
                        completion: AnimationFactory? = nil,
                        cancelation: ContextualAnimation? = nil) {
        let parentController = self.parentViewController
        let animationInContext: ContextualAnimation = { (context: UIViewControllerTransitionCoordinatorContext) in
            animation?(container: parentController, animated: context.isAnimated())()
        }
        let completionInContext = { (context: UIViewControllerTransitionCoordinatorContext) in
            if context.isCancelled() {
                cancelation?(context: context)
            }
            else {
                completion?(container: parentController, animated: context.isAnimated())()
            }
        }
        if let coordinator = transitionCoordinator() {
            coordinator.animateAlongsideTransitionInView(parentViewController?.view, animation: animationInContext, completion: completionInContext)
        }
        else {
            animation?(container: parentViewController, animated: false)()
            completion?(container: parentViewController, animated: false)()
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
